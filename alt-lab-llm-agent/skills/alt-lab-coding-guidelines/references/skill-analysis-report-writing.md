# INFO

This skill teaches an AI assistant how to write analysis reports that are readable to humans while remaining tightly linked to the actual inputs, methods, and outputs that produced the results.

# Skill: Analysis Report Writing

## Purpose

Use this skill when producing a report for a major analysis step.

## Recommended Filename

```text
report.<language-code>.YYYYMMDD_HHMMSS.html
```

## Required Sections

Each major report should contain:

- `Background`
- `Objectives`
- `Input Data`
- `Methods`
- `Results`
- `Interpretation`
- `References`

## Section Guidance

### Background

Explain the scientific or technical context.

### Objectives

State the purpose of the analysis clearly.

### Input Data

List every input file used.

Example:

```text
input/sample1.tsv
input/reference.fa
```

### Methods

Describe:

- analysis strategy
- scripts executed
- workflow file
- software and versions
- important parameters

Also include the workflow file path explicitly.

### Results

Include:

- figures
- tables
- summary statistics
- concise interpretation

Each figure and table should reference the corresponding source output file.

Figures should be embedded directly in the HTML whenever practical, while still citing the source path in the report text or caption.

### Interpretation

Explain significance and limitations.

### References

Include complete citations for external resources, software, databases, or papers used.
