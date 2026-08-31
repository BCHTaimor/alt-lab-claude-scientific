# INFO

This skill teaches an AI assistant how to design and write Bash tests for file-based, script-heavy repositories using realistic fixtures and direct validation of generated outputs.

The focus is on plain shell logic, `bats`, and file-oriented assertions rather than on large testing abstractions.

# Skill: Bash Test Design For File-Based Pipelines

## Purpose

Use this skill when the code under test is mostly shell scripts and the real behavior of the system is expressed through files, directories, exit codes, and generated artifacts.

## Core Idea

The testing style is pragmatic, file-oriented, and shell-native.

It does not try to hide Bash behind a large abstraction layer. Instead, it uses:

- `bats` as the test runner
- real fixture files instead of excessive mocking
- direct assertions on exit codes, stdout, and generated files
- `awk`, `grep`, `wc`, arrays, and `while read` loops to validate business behavior

## Core Rules

### 1. Use `bats`, but keep test logic plain Bash

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

Why this is good:

- shell developers can read it immediately
- failures stay close to the command being tested
- no extra test mini-language is required

### 2. Source shell functions directly when the unit under test is a function

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

### 3. Test scripts through their real entrypoints

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

### 4. Partition tests by scenario

Typical partitions:

- valid input vs invalid input
- single-row input vs multi-row input
- one mode vs another mode
- short values vs long values

Example:

```bash
@test "reverse_complement: rejects invalid characters" {
  run reverse_complement "ACUG"
  [ "$status" -ne 0 ]
  [[ "$output" == *"invalid characters"* ]]
}
```

### 5. Validate real output files with shell tools

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

### 6. Keep temporary directories explicit

Visible temp directories are acceptable when inspectability matters.

Example:

```bash
OUT_DIR=test/unit/TMP
TEST_RESULTS_OUT_DIR=TMP

rm -rf "$OUT_DIR"
rm -rf "$TEST_RESULTS_OUT_DIR"
mkdir -p "$OUT_DIR"
mkdir -p "$TEST_RESULTS_OUT_DIR"
```

### 7. Treat destructive setup examples carefully

Commands shown in documentation are examples only.

Before running destructive commands outside a tightly controlled test context:

- show the exact expanded paths
- obtain explicit approval

## Short Checklist

1. Is the test exercising the real public shell interface?
2. Are the fixtures realistic?
3. Is the assertion checking real output meaning?
4. Are failure cases checking both status and message?
5. Are destructive setup commands constrained and explicit?
