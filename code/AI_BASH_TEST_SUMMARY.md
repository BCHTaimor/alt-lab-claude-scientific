# Bash Test Style Guide For Future Agent Sessions

This document is a standalone summary of a bash-heavy pipeline repo whose tests are written in a style worth copying. It is designed for future AI chats where the repo itself may not be available. The goal is not to describe one specific codebase in a brittle way. The goal is to explain a concrete shell-testing style, show what that style looks like, and make it easy for another agent to reproduce it in a different repository.

## Core idea

The testing style is pragmatic, file-oriented, and shell-native.

It does not try to hide bash behind a large abstraction layer. Instead, it uses:

- `bats` as the test runner
- real fixture files instead of excessive mocking
- direct shell assertions on exit codes, stdout, and generated files
- `awk`, `grep`, `wc`, arrays, and `while read` loops to validate business behavior
- explicit test partitions such as one-row vs multi-row input, valid vs invalid input, or pipeline mode A vs pipeline mode B

Another project should copy this style when:

- the code under test is mostly shell scripts
- the system naturally operates on files
- the value of the test is in checking real generated artifacts
- simple command-line inspection is clearer than building a custom assertion library

## Sample project shape

A repo using this style will often look roughly like this:

```text
project/
├── scripts/
│   ├── generate_fastq.sh
│   ├── naming_schema.sh
│   ├── reverse_complement.sh
│   └── update_metadata.sh
├── test/
│   ├── unit/
│   │   ├── fixtures/
│   │   ├── test_reverse_complement.sh
│   │   ├── test_naming_schema.sh
│   │   ├── test_update_metadata.sh
│   │   └── test_fastq_generated_data.sh
│   └── integrated/
│       ├── fixtures/
│       ├── test_rscript_groseq.sh
│       └── test_rscript_transloc.sh
└── TMP/
```

What this structure demonstrates:

- unit tests and integration tests are separated
- test data lives near the tests
- scripts are tested through their real public interface
- temporary output directories are visible and explicit rather than hidden

That is a strong fit for pipeline repos, where inputs and outputs are usually files and directories rather than pure in-memory values.

## 1. Use `bats`, but keep the test logic plain bash

The preferred test runner is `bats`, but the tests themselves stay close to ordinary shell.

Example:

```bash
#!/usr/bin/env bats

setup() {
  source ./scripts/reverse_complement.sh
}

@test "reverse_complement: ACTG -> CAGT (uppercase)" {
  run reverse_complement "ACTG"
  [ "$status" -eq 0 ]
  [ "$output" = "CAGT" ]
}
```

What the pattern is:

- `bats` provides `@test`, `run`, `$status`, and `$output`
- the assertion style remains basic shell syntax

Why it is good:

- another shell developer can read it immediately
- it avoids introducing a second mini-language on top of bash
- failures tend to be close to the actual command being tested

When another project should reuse it:

- when the project already uses bash heavily
- when readability for shell developers matters more than framework sophistication

## 2. Test small shell functions by sourcing them in `setup()`

When the code under test is a function, source the script and invoke the function directly.

Example:

```bash
#!/usr/bin/env bats

setup() {
  source ./scripts/naming_schema.sh
}

@test "naming_schema: transloc naming format" {
  pipeline="transloc"
  region="VB18"
  read_length="150"
  distortion="None"
  number_reads="5"

  result="$(naming_schema create_name "$pipeline" "$region" "$read_length" "$distortion" "$number_reads")"

  [ "$result" = "Transloc_VB18_PREY150_None_NR5" ]
}
```

What the pattern is:

- source the implementation script once
- call the function with realistic arguments
- assert on the returned string directly

Why it is good:

- it keeps the test focused on one function contract
- it avoids unnecessary subprocess overhead
- it makes string-building helpers easy to validate

When another project should reuse it:

- when the script exposes reusable functions
- when the logic being tested does not depend on process-level side effects

## 3. Test script entrypoints with `run`, not by reimplementing the script in the test

When the unit under test is a script, invoke the script as the user would.

Example:

```bash
@test "update_metadata: generates library and sequencing fields for one row" {
  run ./update_metadata.sh \
    test/unit/fixtures/metadata_row_1.txt \
    test/unit/fixtures/region_file_row_1.tsv \
    150 \
    5 \
    None \
    Transloc \
    test/unit/TMP/metadata_row_1.txt

  [ "$status" -eq 0 ]
}
```

What the pattern is:

- treat the script itself as the public interface
- pass fixture files and real arguments
- assert the process exits successfully before checking outputs

Why it is good:

- it validates the actual CLI contract
- it catches argument handling issues early
- it prevents the test from drifting away from how the script is really used

When another project should reuse it:

- when scripts are invoked directly in production or in pipelines
- when argument order and filesystem behavior matter

## 4. Partition tests by scenario

The underlying style is strongly based on partitioning cases before writing assertions.

Typical partitions in a shell pipeline repo:

- valid input vs invalid input
- single-row input vs multi-row input
- one pipeline mode vs another pipeline mode
- short values vs long values
- one region vs many regions

Example:

```bash
@test "reverse_complement: rejects invalid characters" {
  run reverse_complement "ACUG"
  [ "$status" -ne 0 ]
  [[ "$output" == *"invalid characters"* ]]
}

@test "reverse_complement: rejects empty string" {
  run reverse_complement ""
  [ "$status" -ne 0 ]
  [[ "$output" == *"invalid characters"* ]]
}
```

What the pattern is:

- each `@test` covers one logical partition
- test names encode the scenario, not just the function name

Why it is good:

- it makes coverage easier to reason about
- failures tell you which behavior class broke
- it keeps tests from becoming one giant procedural script

When another project should reuse it:

- always, especially for command-line tools that accept multiple modes or input shapes

## 5. Validate real output files with shell tools

The strongest part of this style is that it checks actual generated artifacts rather than only checking exit codes.

Example:

```bash
@test "update_metadata: generated row contains expected fields" {
  run ./update_metadata.sh \
    metadata_row_1.txt \
    region_file_row_1.tsv \
    150 \
    5 \
    None \
    Transloc \
    test/unit/TMP/metadata_row_1.txt

  [ "$status" -eq 0 ]

  library=$(awk -F "\t" 'NR==2 {print $1}' test/unit/TMP/metadata_row_1.txt)
  sequencing=$(awk -F "\t" 'NR==2 {print $2}' test/unit/TMP/metadata_row_1.txt)

  [ "$library" = "VB18_PREY150_None_NR5" ]
  [ "$sequencing" = "Transloc" ]
}
```

What the pattern is:

- run the real script
- inspect the generated file with `awk`
- assert business meaning, not just file existence

Why it is good:

- it proves the script produced correct domain output
- it keeps the assertions transparent and debuggable
- it avoids black-box snapshots that are hard to interpret

When another project should reuse it:

- when outputs are tabular files, logs, config files, FASTQ files, BED files, TSVs, or other shell-friendly text artifacts

## 6. Use loops and simple text processing for data-driven validation

In file-producing pipelines, one command may generate many outputs. This style accepts that and validates them with loops instead of forcing everything into tiny isolated mocks.

Example:

```bash
@test "generate_fastq: every region produces the expected read structure" {
  run ./scripts/generate_fastq.sh "$BAIT" "$REGION_FILE" "$READ_LENGTH" "$OUT_DIR"
  [ "$status" -eq 0 ]

  line_count=1
  while read -r line; do
    if [[ $line_count == 1 ]]; then
      line_count=$((line_count + 1))
      continue
    fi

    IFS=$'\t' read -r name start end chromosome genome <<< "$line"
    file_name="$(naming_schema create_name "$PIPELINE" "$name" "$READ_LENGTH" "$DISTORTION" "$NREADS")"
    fq_file="$OUT_DIR/generate_fastq_results/preprocess/${file_name}_R1.fq"

    sequence_line=$(awk 'NR==2 {print; exit}' "$fq_file")
    sequence_line_length=$(printf "%s" "$sequence_line" | tr -d '\n' | wc -c)

    [ "$sequence_line_length" -eq "$READ_LENGTH" ]
  done < "$REGION_FILE"
}
```

What the pattern is:

- iterate through a fixture table
- derive expected output names the same way production logic does
- inspect each produced file with command-line tools

Why it is good:

- it matches how pipeline data actually behaves
- it gives broad coverage without inventing fake abstractions
- it keeps the test aligned with filename and output-shape conventions

When another project should reuse it:

- when one input file drives multiple outputs
- when artifact naming and per-record processing are important parts of correctness

## 7. Keep temporary output directories explicit and clean them manually

This style uses visible temporary directories inside the repo such as `test/unit/TMP` or top-level `TMP`.

Example:

```bash
OUT_DIR=test/unit/TMP
TEST_RESULTS_OUT_DIR=TMP

rm -rf "$OUT_DIR"
rm -rf "$TEST_RESULTS_OUT_DIR"
mkdir -p "$OUT_DIR"
mkdir -p "$TEST_RESULTS_OUT_DIR"
```

What the pattern is:

- declare the temp paths near the top of the test
- remove stale state explicitly
- recreate directories before running the script

Why it is good:

- test artifacts are easy to inspect during debugging
- state management is obvious
- failures caused by leftover files become easier to diagnose

When another project should reuse it:

- when inspectable output is more valuable than completely hidden temp isolation
- when developers often debug by opening the generated files

This is a pragmatic choice, not a universal rule. A different project might prefer `mktemp`, but if the goal is to preserve this style, explicit repo-local temp folders are part of it.

## 8. Use negative tests that assert both failure and failure message

A strong bash test style does not stop at “command failed.” It also checks that the failure is meaningful.

Example:

```bash
@test "reverse_complement: rejects invalid characters (U)" {
  run reverse_complement "ACUG"
  [ "$status" -ne 0 ]
  [[ "$output" == *"invalid characters"* ]]
}
```

What the pattern is:

- assert nonzero status
- assert a key substring in stdout or stderr output

Why it is good:

- it proves the script failed for the expected reason
- it guards against regressions where the command still fails but with an unrelated error

When another project should reuse it:

- for input validation
- for branch-specific error handling
- for user-facing CLI diagnostics

## 9. Keep the assertions lightweight and readable

This style avoids heavy helpers such as:

- custom matcher libraries
- large shared assertion utilities
- dense snapshot-based test outputs

Instead it prefers code like:

```bash
[ "$status" -eq 0 ]
[ "$output" = "CAGT" ]
[[ "$output" == *"invalid characters"* ]]
```

And for files:

```bash
value=$(awk -F "\t" 'NR==2 {print $1}' "$OUT_FILE")
[ "$value" = "expected_value" ]
```

What the pattern is:

- use the shell itself as the assertion language

Why it is good:

- it is easy to maintain
- it minimizes indirection
- failures are easier to debug because the assertion logic is obvious

When another project should reuse it:

- when the team prefers directness over test-framework abstraction
- when most contributors are comfortable reading shell one-liners

## 10. Treat helper functions that generate names as first-class things to test

In pipeline repos, generated names are often part of the contract.

Example:

```bash
result="$(naming_schema create_name "groseq" "VB18" "150" "None" "5")"
[ "$result" = "GRO_VB18_RL150_None_NR5" ]
```

What the pattern is:

- test filename and identifier generation directly

Why it is good:

- naming errors can break downstream file discovery
- naming logic is often reused across many scripts
- exact string output is easy to test precisely

When another project should reuse it:

- when filenames encode domain metadata
- when later steps depend on a stable naming convention

## Example commands another repo could copy

When structure matters, include runnable command examples in the summary document so a future agent has something concrete to imitate.

Example:

```bash
bats test/unit/test_reverse_complement.sh
bats test/unit/test_naming_schema.sh
bats test/unit/test_update_metadata.sh
bats test/unit/test_fastq_generated_data.sh
bats test/integrated/test_rscript_groseq.sh
bats test/integrated/test_rscript_transloc.sh
```

Or for a whole suite:

```bash
bats test/unit
bats test/integrated
```

These commands matter because they show:

- the test runner
- the expected folder organization
- the distinction between narrow and end-to-end tests

## What is explicit vs what is inferred

What is explicit in the testing style summarized here:

- `bats` is the test harness
- tests use real files heavily
- tests rely on shell-native validation tools
- partition-based scenario design is present
- unit and integration coverage are separated

What is inferred, but should be stated more carefully:

- the test philosophy values pragmatism over purity
- some “unit” tests are really small integration tests
- temp directory visibility is a deliberate debugging convenience

Those are strong inferences from the test shape, but they should not be oversold as a formal architecture doctrine.

## Recommended rules for future agents

1. Use `bats` for new bash tests unless the repo already uses something else.
2. Write tests so they still make sense to a shell developer reading plain bash.
3. Partition behavior first, then create one clear `@test` per scenario.
4. Source function libraries in `setup()` when you want direct function-level testing.
5. Invoke scripts with `run` when the CLI or process boundary is part of the contract.
6. Prefer real fixture files over mocking when the code naturally works on files.
7. Validate business meaning in output files with `awk`, `grep`, `wc`, arrays, and `while read`.
8. Check both exit status and content, especially for failure cases.
9. Keep temporary output directories explicit and clean them manually when preserving this repo style.
10. Test naming helpers directly when generated filenames are part of the workflow contract.
11. Avoid adding a large assertion DSL unless the project explicitly asks for it.
12. If writing a summary document for another chat, include embedded examples and commands so the document survives without repo access.

## Short summary

The main lesson is not just “use `bats`.” The deeper lesson is to keep bash tests close to how bash pipelines really work: real files, real commands, explicit partitions, transparent assertions, and output validation done with ordinary shell tools. That combination makes the test suite easy to understand, easy to debug, and easy for a future agent to imitate in a completely different repository.
