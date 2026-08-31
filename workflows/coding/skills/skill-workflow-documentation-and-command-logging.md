# INFO

This skill teaches an AI assistant how to record reproducible workflows as explicit Bash command histories with enough context for another person or agent to rerun the work later.

# Skill: Workflow Documentation And Command Logging

## Purpose

Use this skill when documenting how an analysis was run or when creating a workflow file intended to reproduce a result end to end.

## Recommended Filename

```text
work_flow.<task>.YYYYMMDD.sh
```

If the workflow is revised multiple times on the same day:

```text
work_flow.<task>.YYYYMMDD_HHMMSS.sh
```

## Workflow Format

Whenever practical, the workflow should be valid Bash that can be copied, pasted, or executed with minimal modification.

Start executable workflow files with:

```bash
#!/usr/bin/env bash
```

## Record In Comments

Use Bash comments to record:

- analysis objective
- input files
- expected output files
- software and versions
- important parameters
- notes
- assumptions
- warnings or limitations

Use `cd` explicitly when commands depend on the working directory.

Example:

```bash
#!/usr/bin/env bash

# Date: 2026-07-16
# Analysis objective:
# Summarize VDJ junction usage from the input TLX files.

# Software version:
#   Perl 5.34.0
#   R 4.4.1

# Working directory:
cd /project/VDJ_analysis

# Summarize VDJ
perl scripts/summarize_vdj.pl \
    --input data/sample1.tlx \
    --output output/VDJ_summary.20260710.tsv
#  Wed Jul 15 15:06:11 EDT 2026  end  (2min12s)
# Input files:
#   data/sample1.tlx
# Output files:
#   output/VDJ_summary.20260710.tsv
```

## Long-Running Commands

For expensive stages, record:

- start time
- end time
- elapsed time
- exit status when practical

## Security Rule

Do not record secrets such as passwords, tokens, private keys, or session cookies directly in the workflow.
