# Workflow Files

Every major analysis should have a corresponding workflow file that records the commands required to reproduce the analysis.

Recommended filename:

```text
work_flow.<task>.YYYYMMDD.sh
```

For example:

```text
work_flow.VDJ_summary.20260710.sh
```

If the workflow is created or substantially updated multiple times on the same day, include a timestamp:

```text
work_flow.<task>.YYYYMMDD_HHMMSS.sh
```

For example:

```text
work_flow.VDJ_summary.20260710_153045.sh
```

## Workflow Format

Whenever practical, record commands as valid Bash that can be copied and pasted into a terminal or executed as a script with minimal manual modification.

Begin executable workflow files with:

```bash
#!/usr/bin/env bash
```

Use Bash comments beginning with `#` to record explanatory information, including:

* analysis objective
* input files
* expected output files
* software and software versions
* important parameters
* notes
* assumptions
* warnings or known limitations

Use `cd` to explicitly record the working directory when the commands depend on the current directory.

For example:

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

Prefer explicit paths, arguments, and output filenames over commands that depend on undocumented shell state or manual file selection.

Commands should preserve the actual execution order.

## Command Inputs and Outputs

Before each major command or command group, use comments to document:

* the purpose of the command

After each major command or command group, use comments to document:

* its input files
* its output files
* important parameters or assumptions

For example:

```bash
# Filter alignments with MAPQ >= 30.
samtools view \
    -@ 8 \
    -b \
    -q 30 \
    aligned/sample1.bam \
    > filtered/sample1.mapq30.bam
#  Wed Jul 15 15:06:11 EDT 2026  end  (2min12s)
# Input:
#   aligned/sample1.bam
# Output:
#   filtered/sample1.mapq30.bam

```

## Long-Running Commands

For commands that may take a substantial amount of time, record:

* start timestamp
* end timestamp
* elapsed execution time
* exit status when practical

A recommended pattern is:

```bash
# Purpose
(date
echo command
time command
date) |& cat >log
#  Wed Jul 15 15:06:11 EDT 2026  end  (2min12s)

```

When several long-running commands occur in one workflow, record timing information separately for each major command or stage.

## Reproducibility

The workflow should contain enough information to reproduce the analysis without relying on undocumented chat context.

Avoid including:

* passwords
* authentication tokens
* private keys
* session cookies
* temporary credentials
* commands that expose secrets

If a required value is sensitive, refer to an environment variable or external configuration file instead of recording the value directly.

For example:

```bash
some_command --token "${ACCESS_TOKEN}"
```
