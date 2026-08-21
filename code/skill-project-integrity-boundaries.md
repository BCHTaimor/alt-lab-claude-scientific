# INFO

This skill teaches an AI assistant how to preserve project integrity while working in an established repository.

The focus is on protecting original data, preserving traceability, and preferring additive work over destructive edits so that the project remains safe for future collaborators.

# Skill: Project Integrity Boundaries

## Purpose

Use this skill at the start of any coding or analysis task inside an existing project.

The goal is to keep the repository understandable and safe even after many incremental changes.

## Core Rules

1. Never modify or delete original data.
2. Never modify or delete the `original/` directory.
3. Never modify or delete the main project guidance file unless the user explicitly instructs you to do so.
4. Preserve reproducibility.
5. Preserve traceability.
6. Every important analysis should be reproducible from documented inputs, scripts, and workflows.
7. Prefer creating new files rather than overwriting existing ones.

## Why This Matters

These rules reduce several common failures:

- accidental loss of source data
- irreproducible analyses
- hidden changes to previously trusted outputs
- repository states that only the original author understands

## Practical Guidance

When the task requires working from raw source material:

- copy it into `input/`
- or create symbolic links
- or derive new outputs under `output/`

Do not destroy evidence of how a result was produced just to make the project look tidier.

## Short Checklist

Before making changes, ask:

1. Am I touching original data?
2. Am I overwriting something that should remain historical?
3. Will another person be able to tell what changed and why?
4. Could this result be regenerated later from the repo?
