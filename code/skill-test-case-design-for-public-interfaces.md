# INFO

This skill teaches an AI assistant how to design test cases around public behavior, meaningful partitions, and explicit contracts rather than private implementation details.

It is meant for general coding work, not specifically scientific applications. The focus is on choosing the right test scope, separating unit tests from integration tests, and building test cases that reflect real behavior classes.

# Skill: Test Case Design For Public Interfaces

## Purpose

Use this skill when writing or revising tests for a codebase with public functions, public methods, public classes, or command-line entrypoints.

The goal is to produce tests that:

- target public behavior by default
- distinguish unit tests from integration tests correctly
- partition cases over meaningful inputs and edge conditions
- validate class contracts and function behavior clearly
- avoid wasting effort on private implementation details unless specifically requested

## Core Rules

### 1. Test public functions and methods by default

Write test cases for public functions, public methods, and public classes.

Do not test private helpers such as `_function` unless:

- the user explicitly asks for it
- the helper contains important standalone logic
- the behavior cannot be covered meaningfully through a public interface

This keeps the tests aligned with the real API surface.

### 2. Distinguish unit tests from integration tests correctly

A unit test should focus on one public behavior surface.

An integration test should cover behavior that crosses multiple functions, classes, or modules.

Rule of thumb:

- unit test: one public behavior surface
- integration test: collaboration across components

### 3. Partition test cases over relevant information

Usually this means partitioning over:

- parameters
- valid vs invalid inputs
- special edge cases
- boundary values
- major behavior branches

## Testing Public Class Contracts

When testing a class, focus on the contract rather than the internals.

For a class like `FileType`, the test surface should concentrate on behaviors such as:

- `validation_function`
- `generate_filename`
- `generate_example_filename`
- `check_rep` when it enforces a public invariant

### Validator Tests

Define:

- representative valid examples
- representative invalid examples
- invalid cases that fail for different reasons

### Generator Tests

Test both:

- valid inputs that should produce exact expected outputs
- invalid inputs that should fail explicitly

### Invariant Tests

If the class defines an invariant, write tests that enforce the relationship between public methods rather than only checking isolated outputs.

## Testing Public Functions

Before writing tests for a standalone function, define its behavior clearly enough to describe meaningful partitions.

For interpolation-style functions, likely partitions include:

- boundary already present
- boundary missing but interpolatable
- boundary too far away
- malformed or empty inputs

Prefer behavior-driven edge cases over arbitrary numbers.

## Example Class Contract

Example target list:

```text
FileType():
    check_rep(): SignalFile
    validation_function(self, file): SignalFile, valid_filenames, invalid_filenames
```

This is strong because it identifies the public behaviors to test instead of listing internals blindly.

For a class like:

```python
class FileType():
    """
    AF(pattern) => creates filenames and can validate if a file name matches a particular pattern.
                    Also generates names for files made form combining files that match the pattern

    Rep Invarient:
        filenames created by generate_filename() pass the validation_function():

    Protection From rep exposure():
        the field pattern is never exposed in any functions
    """
```

the test surface should focus on public behaviors such as:

- `validation_function`
- `generate_filename`
- `generate_example_filename`
- `check_rep` when it enforces a public invariant

## Example Validator Test

If a method validates structured strings such as filenames, define:

- representative valid examples
- representative invalid examples
- invalid cases that fail for distinct reasons

Example:

```python
def test_FileType_SignalFile_validation_function():
    valid_filenames = [
        "SNTG1_20240103_U2OS_APH_10000_20000_noise.png",
        "GENE1_sample1_desc1_DMSO_10000_20000_signal.png"
    ]
    invalid_filenames = [
        "SNTG1_20240103_U2OS_APH_10000_2000.png",
        "SNTG1_20240103_U2OS_WRONG_1000_2000_noise.png",
        "SNTG1_20240103_U2OS_APH_invalid.png",
        "SNTG1_20240103__APH_noise.png",
        "SNTG1_20240103_U2OS_APH_noise.jpg",
        ""
    ]

    signal_file = SignalFile()

    for filename in valid_filenames:
        result = signal_file.validation_function(filename)
        assert result, f"Valid filename '{filename}' failed validation"

    for filename in invalid_filenames:
        result = signal_file.validation_function(filename)
        assert not result, f"Invalid filename '{filename}' passed validation"
```

This is strong because each invalid example represents a different failure mode.

## Example Generator Test

If a public method constructs outputs, test both:

- valid inputs that should produce exact expected outputs
- invalid inputs that should fail explicitly

Example:

```python
def test_FileType_SignalFile_generate_filename():
    valid_inputs = [
        ("BRCA1", "U20", "exon", "DMSO", "original"),
        ("TP53", "U20", "intron", "APH", "noise"),
        ("BRCA2", "U20", "exon", "APH", "signal")
    ]

    invalid_inputs = [
        ("", "sample_001", "exon", "chemutilsapy", "control"),
        ("$", "sample_001", "exon", "chemutilsapy", "control"),
        ("BRCA1", "$sample", "exon", "chemutilsapy", "control"),
        ("BRCA1", "sample_001", "$something", "chemutilsapy", "control"),
        ("BRCA1", "sample_001", "exon", "$treatment", "control"),
        ("BRCA1", "sample_001", "exon", "chemutilsapy", "$category"),
    ]

    signal_maker = SignalFile()

    for gene, sample, something, treatment, category in valid_inputs:
        result = signal_maker.generate_filename(gene, sample, something, treatment, 10000, 20000, category)
        expected = f"{gene}_{sample}_{something}_{treatment}_10000_20000_{category}.png"
        assert result == expected

    for gene, sample, something, treatment, category in invalid_inputs:
        with pytest.raises(ValueError):
            signal_maker.generate_filename(gene, sample, something, treatment, 10000, 20000, category)
```

This is strong because it tests both successful construction and explicit rejection.

## Example Function Target

For a standalone function, build the test plan around the function’s public contract.

Example function:

```python
def pad_interpolate(start, end, x, y, padding=2):
    """
    @param start, the start x-value
    @param end, the end x value
    @param x
    @param y
    @param padding, how far from start or end you can interpolate with
    @returns a new x,y in array as a tuple with the start and end added at correctly interpolated points
    """
```

Before writing tests, define the real behavior clearly. For interpolation-style functions, likely partitions include:

- `start` already exists
- `end` already exists
- `start` missing but interpolatable
- `end` missing but interpolatable
- both missing but interpolatable
- interpolation blocked because the boundary is too far away
- malformed or empty inputs

A test plan should follow behavior, not guesswork.

## Recommended Output Style

When applying this skill, generated tests should usually have:

- one clear public target per test group
- explicit valid and invalid partitions
- meaningful edge cases
- exact expected outputs where practical
- invariant checks for constrained classes
- integration tests only when multiple components truly collaborate

## When To Use This Skill

Use this skill when:

- writing unit tests for public functions or methods
- deciding whether something is a unit test or an integration test
- testing validators, generators, parsers, or other contract-heavy code
- improving weak tests that currently rely on random examples
- reviewing whether test coverage matches the actual public API

Do not use this skill to justify testing every private helper automatically.

## Short Checklist

1. Am I testing a public interface rather than an internal helper?
2. Is the test scope really unit or really integration?
3. Do the cases represent meaningful partitions?
4. Are invalid inputs failing for distinct reasons?
5. Am I validating the actual contract of the function or class?

## Summary

This skill teaches an AI assistant to design tests around public behavior, explicit contracts, and meaningful partitions rather than implementation trivia.
