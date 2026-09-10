# INFO

This skill teaches an AI assistant how to structure work so outputs and reports can be regenerated later from documented project inputs and workflows.

# Skill: Reproducible Analysis Design

## Purpose

Use this skill when writing scripts, designing workflows, or evaluating whether a project is reproducible.

## Reproducibility Contract

A complete analysis should be reproducible using only:

```text
original/
input/
scripts/
work_flows/
```

to regenerate:

```text
output/
reports/
```

## Do Not Depend On

- desktop files
- downloads that are not documented
- temporary directories
- manually edited intermediate files
- undocumented commands

## Expected Behavior

When this skill is applied well, a future collaborator should be able to regenerate the outputs from the repo and documented environment alone.
