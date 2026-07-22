# Output Organization Policy

The `output/` directory should remain well organized and easy to navigate.

If a project generates only a small number of output files, they may be stored directly under `output/`.

If many output files are produced, create appropriate subdirectories to organize them.

Preferred organization methods include:

1. By working date (recommended)

```text
output/
    20260710/
    20260711/
```

2. By analysis task

```text
output/
    reanalyze/
    QC/
    VDJ_summary/
```

3. By combining both date and task (recommended for large projects)

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

The organization method should be selected to maximize readability and reproducibility.

AI agents may create additional subdirectories (e.g., tables/, figures/, logs/, intermediate/) within an analysis directory when doing so improves organization and clarity.

Avoid creating unnecessarily deep directory hierarchies.

Workflow files and reports should always reference the relative paths of all output files.

Output files belonging to the same analysis should be stored together whenever practical.
