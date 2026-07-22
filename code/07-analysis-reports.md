# Analysis Reports

Each major analysis should generate an HTML report.

Recommended filenames:

```
report.<language-code>.YYYYMMDD_HHMMSS.html
```

Each report should contain the following sections.

## Background

Scientific background.

## Objectives

Purpose of the analysis.

## Input Data

List every input file used.

Example:

```
input/sample1.tsv

input/reference.fa
```

## Methods

Describe:

* analysis strategy
* scripts executed
* workflow file
* software
* software versions
* important parameters

Example:

```
R 4.5.0

samtools 1.22

bwa 0.7.19

Bioconductor 3.x
```

Also include the workflow file path.

Example:

```
work_flows/work_flow.VDJ_summary.20260710.sh
```

## Results

Include:

* figures
* tables
* summary statistics
* interpretation

Each figure should reference its corresponding file.

Example:

```
output/VH_usage.pdf
```

Each table should reference its source.

Example:

```
output/VH_usage.tsv
```

Figures should be embedded directly in the HTML report whenever practical, preferably as self-contained image data URIs or otherwise packaged so the report can be opened and shown without broken image links.

Each embedded figure should still reference its source output file path in the report text or caption.

Example:

```text
Figure source: output/VH_usage.20260710.png
```

## Interpretation

Explain biological and computational significance.

Discuss limitations where appropriate.

## References

If external resources are used, include complete citations.

Examples:

* journal articles
* GitHub repositories
* genome assemblies
* downloaded databases
* software documentation
* URLs
