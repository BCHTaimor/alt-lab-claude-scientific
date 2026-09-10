# INFO

This skill teaches an AI assistant how to create outputs without overwriting history or relying on ambiguous generic filenames.

# Skill: Output File Discipline

## Purpose

Use this skill whenever the task generates or updates result files.

## Core Rules

- avoid overwriting previous results
- prefer new files with date-based suffixes
- use `YYYYMMDD` when outputs are generated no more than once per day
- use `YYYYMMDD_HHMMSS` when multiple outputs may be generated on the same day

## Recommended Formats

```text
result.YYYYMMDD.tsv
result.YYYYMMDD_HHMMSS.tsv
```

## Avoid

Do not repeatedly overwrite filenames like:

```text
result.tsv
```

## Time Rule

Use timestamps based on the established working date and local time for the current task.
