# INFO

This skill teaches an AI assistant how to organize the `output/` directory so generated artifacts remain grouped, readable, and easy to reference from workflows and reports.

# Skill: Output Directory Organization

## Purpose

Use this skill when deciding where generated outputs should be stored.

## Core Rules

If a project generates only a few outputs, they may be stored directly under `output/`.

If many outputs are produced, organize them in a way that improves readability and reproducibility.

## Recommended Patterns

### By Working Date

```text
output/
    20260710/
    20260711/
```

### By Analysis Task

```text
output/
    reanalyze/
    QC/
    VDJ_summary/
```

### By Combining Date And Task

```text
output/
    reanalyze_20260710/
    QC_20260710/
    VDJ_summary_20260711/
```

or

```text
output/
    20260710/
        QC/
        reanalyze/
```

## Additional Guidance

- select the structure that maximizes readability and reproducibility
- avoid unnecessarily deep directory hierarchies
- keep related outputs together
- use subdirectories like `tables/`, `figures/`, `logs/`, or `intermediate/` when they improve clarity
- ensure workflow files and reports reference relative paths to outputs
