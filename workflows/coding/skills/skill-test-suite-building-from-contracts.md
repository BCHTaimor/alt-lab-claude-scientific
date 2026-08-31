# INFO

This skill teaches an AI assistant how to build a complete test suite from a function, class, or pipeline contract. It organizes coverage around valid behavior partitions, natural boundaries, and meaningful interactions instead of a generic collection of malformed inputs.

# Skill: Test Suite Building From Contracts

## Purpose

Use this skill when designing or revising a test suite for a public function, class, command-line interface, or pipeline.

The goal is to demonstrate that the specified behavior works across the meaningful parts of its valid input domain. A test suite should cover natural boundaries, defined invariants, and important interactions without coupling to private implementation details.

## Required Process

Before writing or changing tests:

1. Read the target's stated inputs, outputs, preconditions, and invariants.
2. Separate validation responsibilities from core behavior.
3. List valid input partitions for every parameter.
4. Identify natural boundaries and specification-defined special values.
5. Identify parameter interactions that can change the observable result.
6. Present the proposed partitions and test matrix before implementation, unless the user explicitly requests immediate implementation.

## Contract-First Test Implementation Rule

When creating or revising code with tests, establish the implementation contract before writing or changing tests.

### Required order

1. Identify every new or modified public command, public function, public method, and developer-facing module API.
2. Write or update a contract beside each target before adding tests.
3. State each contract's inputs, outputs or side effects, preconditions, invariants, and domain-specific semantics where applicable.
4. Derive valid input partitions and natural boundaries from those contracts.
5. Present the proposed test matrix before implementation, unless the user explicitly requests immediate implementation.
6. Implement tests only after the contract and test matrix are established.
7. Add the implemented test-suite matrix as a comment at the top of every relevant test file.

### Test traceability

Every test must trace to a named source contract partition. At the top of each relevant test file, add a short comment in this format:

```text
Contract target: generate_fastq.sh

Partitions:
  PRO-seq: no adapter, exact-fill adapter, clipped adapter
  Distortion: none, rate 0, intermediate rate, rate 1
  Windows: exact-length region, multiple windows
  Replicates: one, multiple

Invariants:
  every FASTQ record has four lines
  sequence and quality lengths match
  every canonical generated read has exactly one key-file row
  same input and seed produces identical output
```

Keep this matrix current when the contract or suite changes. It is a traceability summary, not a substitute for test names that identify the precise behavior and partition being tested.

## Separate Test Levels

### Validation layer

Test malformed or unsupported input only where validation is part of the public contract.

Examples:

- a required command-line argument is absent
- an unsupported pipeline name is supplied
- a value is outside the documented accepted range
- a required input file does not exist

Do not repeat those checks in lower-level function tests when those functions correctly assume validated input.

### Core function layer

Assume the function receives inputs that meet its stated preconditions. Test:

- defined behavior
- valid equivalence partitions
- natural boundary values
- output invariants
- domain-specific semantics

Do not test undefined behavior merely because it is technically possible to call a function incorrectly.

## Partition Inputs By Behavior

Partition inputs according to behavior, not data type alone.

Good partitions:

```text
substitution rate:
  0
  0 < rate < 1
  1

read position:
  first valid position
  interior position
  final valid position

adapter relationship:
  no adapter
  adapter begins within the read
  adapter exactly fills the remaining read space
```

Poor partitions:

- every arbitrary integer value
- malformed values in a function that assumes validation already occurred
- random examples with no behavioral distinction

## Test Natural Boundaries

Test boundaries only when they are valid and meaningful within the contract. Typical natural boundaries include:

- `0` and `1`
- exactly `N`, `N - 1`, and `N + 1`
- first and final valid positions
- an empty result when empty output is valid
- one item and multiple items

Do not test values outside the specified domain unless the test targets the validation layer.

## Test Interactions Selectively

Do not test every possible parameter combination. Cover a combination only when its parameters influence one another.

Examples:

```text
PRO-seq:
  adapter layout x insert length
  strand x genomic window position
  distortion x deterministic seed

Transloc:
  bait length x prey length x total read length

GRO-seq:
  paired-read layout x strand x replicate count
```

Choose the smallest set of cases that covers each interaction boundary.

## Test Observable Contracts

Assert externally meaningful behavior rather than internal implementation choices.

Prefer assertions such as:

- every FASTQ record has four lines
- sequence and quality strings have equal lengths
- every generated read has one matching key-file row
- positive and negative reads follow the documented orientation rule
- the same seed and input produce identical output

Avoid assertions about:

- temporary-variable names
- internal helper-call order
- unspecified formatting details
- implementation choices that may safely change

## Make Random Behavior Deterministic

Stochastic behavior must be testable deterministically.

- Use a fixed seed in test fixtures.
- Verify that identical input and seed produce identical output.
- Do not assume a different seed must always produce a different output.
- When an effect must be guaranteed, choose an observable contract boundary such as substitution rate `1` instead of relying on chance at a low rate.

## Build Class-Wide Coverage From Public Methods

For a class, first list every public method and the return types or behavior partitions it owns. Test each implementation of that behavior across the class rather than treating the class as one opaque unit.

Example public surface:

```text
FileType:
    check_rep(): SignalFile, TerminationFile
    validation_function(self, file): SignalFile, TerminationFile
```

This produces a matrix in which the rows are public methods and the columns are concrete implementations or meaningful behavior partitions:

| Public behavior | SignalFile | TerminationFile |
| --- | --- | --- |
| `check_rep()` | representative valid state and invariant | representative valid state and invariant |
| `validation_function(file)` | valid filename, invalid structural variant | valid filename, invalid structural variant |

The suite should prove each concrete implementation fulfills the same public contract, while preserving implementation-specific semantics where they are documented.

### Example class test plan

```python
import pytest


@pytest.mark.parametrize(
    ("file_type", "valid_filename", "invalid_filename"),
    [
        (
            SignalFile(),
            "SNTG1_20240103_U2OS_APH_10000_20000_signal.png",
            "SNTG1_20240103_U2OS_APH_invalid.png",
        ),
        (
            TerminationFile(),
            "SNTG1_20240103_U2OS_APH_10000_20000_termination.png",
            "SNTG1_20240103_U2OS_APH_invalid.png",
        ),
    ],
)
def test_file_type_validation_function_accepts_and_rejects_contract_partitions(
    file_type,
    valid_filename,
    invalid_filename,
):
    assert file_type.validation_function(valid_filename)
    assert not file_type.validation_function(invalid_filename)


@pytest.mark.parametrize("file_type", [SignalFile(), TerminationFile()])
def test_file_type_check_rep_preserves_the_public_representation_invariant(file_type):
    result = file_type.check_rep()

    assert_representation_invariant(result, file_type)
```

`assert_representation_invariant` stands for the class-specific assertion defined by the documented contract. Do not replace it with an invented expectation. Use parameterization when the same contract applies across implementations, and separate tests where an implementation has a documented behavior that differs materially from the others.

## Name Tests By Behavior And Partition

Each test name should identify the public behavior and partition it covers.

Good names:

- `distort_sequence: substitution rate 0 preserves sequence`
- `proseq generator: adapter exactly fills remaining read length`
- `transloc generator: minimum valid prey length preserves total read length`
- `groseq generator: multiple windows produce paired records`
- `file type: validation function rejects a missing required field`

Poor names:

- `test_proseq`
- `test_edge_case`
- `test_generator_works`

## Keep Fixtures Small And Clear

Use the smallest fixture that makes the expected behavior obvious. Fixtures should be:

- small
- deterministic
- human-readable
- domain-specific when needed
- free of unnecessary experimental data

Prefer a small synthetic sequence, filename, or input table over a large real data file unless real data is necessary to establish a documented convention.

## Example: FASTQ Pipeline Test Matrix

```text
generate_fastq()
  validation layer:
    required public arguments
    supported pipeline selection

  PRO-seq generator:
    no adapter
    adapter begins within read
    adapter exactly fills remaining read length
    first and last valid genomic windows
    positive and negative strand orientation
    one and multiple reads per position

  GRO-seq generator:
    one and multiple windows
    one and multiple replicates
    positive and negative strand orientation
    defined R1/R2 layout

  Transloc generator:
    minimum valid prey length
    bait plus prey equals total read length
    positive and negative prey orientation
    defined R1/R2 layout

  distortion:
    none
    rate 0
    intermediate valid rate
    rate 1
    truncate at 1 base
    truncate at full sequence length
```

## Completion Criteria

Before claiming a test suite is complete, confirm that:

- each test maps to a stated contract partition
- natural valid boundaries are covered
- core-function tests do not cover undefined behavior
- validation tests are isolated to the validation layer
- random behavior is deterministic
- integration tests cover only meaningful parameter interactions
- the suite does not require a long-running external pipeline unless the user explicitly requested it

## When To Use This Skill

Use this skill when:

- building a new test suite from a function, class, or pipeline specification
- expanding narrow test coverage into meaningful behavior partitions
- designing test matrices for class hierarchies or multiple implementations
- reviewing whether a test suite is justified by its public contracts
