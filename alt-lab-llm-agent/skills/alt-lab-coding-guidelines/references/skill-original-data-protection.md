# INFO

This skill teaches an AI assistant to treat original source data and explicitly protected artifacts as immutable.

# Skill: Original Data Protection

## Purpose

Use this skill whenever the task touches raw inputs or source-of-record files.

## Core Rules

Never modify:

```text
original/
AGENTS.md
```

Never overwrite raw data.

If preprocessing is required:

- create copies in `input/`
- or create symbolic links
- or derive new files elsewhere

## Why This Matters

Immutable source material makes it possible to audit and reproduce later work.
