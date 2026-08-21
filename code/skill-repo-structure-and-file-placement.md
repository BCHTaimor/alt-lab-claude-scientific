# INFO

This skill teaches an AI assistant how to organize a project into predictable directories so data, scripts, outputs, workflows, and reports remain easy to locate and reason about.

# Skill: Repo Structure And File Placement

## Purpose

Use this skill when designing a repository layout or deciding where a new file belongs.

## Recommended Structure

```text
Project/
├── AGENTS.md
├── README.md
├── original/
├── input/
├── scripts/
├── output/
├── work_flows/
├── reports/
├── docs/
└── .git/
```

## Directory Definitions

### `original/`

Contains immutable source materials.

Examples:

- raw sequencing data
- downloaded databases
- published supplementary files
- original spreadsheets

Rules:

- never edit
- never rename
- never delete
- if processing is needed, copy files into `input/` or create symbolic links

### `input/`

Contains working inputs for analysis.

Examples:

- copied data
- symbolic links to individual large files
- prepared intermediate inputs

Rules:

- symbolic links should point to files, not directories
- do not hide required inventory behind directory-level links
- make source provenance explicit in the workflow

### `scripts/`

Contains executable analysis logic.

Rules:

- place primary scripts directly under `scripts/`
- do not create date-based subdirectories here
- use non-date subdirectories only when they reduce real complexity

Typical languages:

- R
- Perl
- Python
- Bash

### `output/`

Contains generated artifacts such as TSV, CSV, TXT, PDF, PNG, SVG, or HTML.

Rule:

- do not manually edit output artifacts

### `work_flows/`

Contains reproducible workflow descriptions.

Each workflow should fully document how one analysis was run.

### `reports/`

Contains human-readable summaries of completed analyses.
