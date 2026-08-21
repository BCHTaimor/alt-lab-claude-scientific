# INFO

This skill teaches an AI assistant to name files clearly and version them in a way that preserves ordering, traceability, and interpretability.

# Skill: File Naming And Versioning

## Purpose

Use this skill when naming scripts, reports, tables, plots, or outputs that may accumulate over time.

## Core Naming Rule

Use descriptive filenames with date suffixes:

```text
name.YYYYMMDD.ext
```

Examples:

```text
parse_reads.20260710.pl
summarize_VDJ.20260710.R
plot_VH_usage.20260710.R
statistics.20260710.tsv
```

## Multiple Versions On The Same Day

If multiple versions are produced on the same day, add a version suffix:

```text
plot_VH_usage.20260710_v2.R
plot_VH_usage.20260710_v3.R
```

## Avoid

Avoid vague names such as:

```text
test.R
new.R
script.py
final.pdf
```

## Why This Matters

Good filenames reduce ambiguity and make it easier to:

- find the latest version
- compare historical versions
- understand file purpose without opening it
