# README And Usage Guide Pattern

This guide is a reusable summary of what makes a repository README especially effective for analytical and pipeline-heavy projects. It includes concrete examples so it can be used outside the original codebase.

## Core idea

A strong README should answer these questions quickly:

- What problem does this project solve?
- What are the main operating modes?
- What inputs are required?
- What commands should I run first?
- What outputs should I expect?
- How do I run tests?
- What supporting scripts exist?

The README style from this repo is strong because it answers all of those directly.

## 1. Start with domain context before setup instructions

An effective README begins by explaining the problem space, not by jumping straight to installation.

Example style:

```text
OK-seq data comes in the form of a signal-like graph with RFD as the Y-axis and genomic coordinate as the X-axis.
The pipeline analyzes this wave-like data by determining when the signal has meaningfully crossed a boundary and
quantifies those regions into zones.
```

Why this is good:

- a new reader understands the project’s purpose before seeing commands
- future agents get the domain model early
- command examples later in the README have context

## 2. Explain major operating modes clearly

If a repo has multiple main methods, the README should state them explicitly.

Example:

- `zone`: classify initiation and termination behavior from the signal
- `decompose`: estimate a threshold boundary from signal decomposition

Good README behavior is to explain both the purpose and the difference between them.

Example explanatory style:

```text
Using the `decompose` method, the pipeline estimates the boundary condition used by the `zone` method by separating
broad signal trends from local residual noise and deriving a conservative threshold from the residual distribution.
```

## 3. Show exact input formats

A README becomes much more useful when it shows the shape of required inputs.

Example BED format section:

```text
chr1    1000    1100    DLG2
chr1    1100    1200    MACROD2
chr1    1200    1300    PCDH15
```

Example BDG format section:

```text
chr1    1000    1100    0.0
chr1    1100    1200    0.31
chr1    1200    1300    0.59
```

Why this matters:

- users can format data correctly without reading code
- agents can generate compatible mock inputs
- debugging becomes faster because expected structure is visible

## 4. Include quick-start commands that are actually runnable

A strong README gives at least one minimal example for each main operating mode.

Example minimal `zone` run:

```bash
sh ok-seq.sh \
  -bed test/test_data/integration_test_folder/correct_number_points/test_bed.12282024.bed \
  -bdg test/test_data/integration_test_folder/correct_number_points/U2OS_DMSO.20250108.RFD.smooth_each_side_30kb.bdg \
  --method zone
```

Example minimal `decompose` run:

```bash
sh ok-seq.sh \
  -bed test/test_data/integration_test_folder/Decompose_test/test_bed.12282024.bed \
  -bdg test/test_data/integration_test_folder/Decompose_test/U2OS_DMSO.20250108.RFD.smooth_each_side_30kb.bdg \
  --method decompose
```

This is better than a generic placeholder because it gives a known-good path.

## 5. Include one advanced example with optional inputs

The README should also show a more realistic command with optional arguments.

Example:

```bash
sh ok-seq.sh \
  -bed /path/to/intergenic_rdc.04302026.bed \
  -bdg /path/to/U2OS_DMSO.20240103.RFD.smooth_each_side_30kb.bdg \
       /path/to/U2OS_APH.20240103.RFD.smooth_each_side_30kb.bdg \
  --GROseq-DMSO /path/to/dmso_neg.bdg /path/to/dmso_pos.bdg \
  --GROseq-APH /path/to/aph_neg.bdg /path/to/aph_pos.bdg \
  --HTGTSpeaks-APH /path/to/U2OS_chr5_APH_conct_norm.tlx \
  --HTGTSpeaks-DMSO /path/to/U2OS_chr5_DMSO_Merged_10K.tlx \
  --method zone \
  --out test/test_run \
  --defaults "[0.15,10,0.06]"
```

Why this is useful:

- it shows the full surface area without forcing every user into advanced options
- it acts as a template for real runs

## 6. Document expected output structure

One of the strongest README habits is showing the shape of the output directory.

Example:

```text
my_run/
├── dump/
│   ├── DLG2_20240103_U2OS_APH_83132232_84039306_region_results.csv
│   ├── DLG2_20240103_U2OS_APH_83132232_84039306_signal_OkSeq.png
│   └── DLG2_20240103_U2OS_APH_83132232_84039306_whole_region_results.csv
├── csv_files/
│   └── intergenic_rdc_04302026/
│       ├── intergenic_rdc_04302026_all_genes_combined_regions.csv
│       └── intergenic_rdc_04302026_all_genes_whole_combined_regions.csv
├── img_files/
│   └── OkSeq_GroSeq_HTGTS/
└── log.log
```

Why this is excellent documentation:

- users know whether a run succeeded structurally
- test writers know what artifacts to assert
- agents can reason about downstream files without guessing

## 7. Include test commands explicitly

Do not assume people know how to run the tests.

Example:

```bash
python3 -m pytest test/
python3 -m pytest test/test_area_under.py
python3 -m pytest test/test_file_type.py
python3 -m pytest test/test_regions.py
python3 -m pytest test/integration_test.py
```

This is especially important in research or pipeline repos where users may run only a subset first.

## 8. Include supplemental and maintenance commands

A README becomes much more operationally complete when it includes:

- how to run support scripts
- how to clean generated outputs
- how to install dependencies

Example:

```bash
python3 -m supplemental.zone_process
python3 -m supplemental.decompose_process

sh clean_repo.sh
sh supplemental/clean_supplemental.sh
sh test/clean_test_run.sh
sh utils/clean_utils_run.sh

pip install -r requirements.txt
```

Why this matters:

- it captures the real working surface of the repo
- it reduces tribal knowledge

## 9. Recommended README outline for similar projects

If you want to reproduce this documentation quality elsewhere, use this structure:

1. Project/domain overview
2. Main operating modes
3. Required input formats with examples
4. Optional arguments
5. Output directory examples
6. Quick-start commands
7. Advanced command examples
8. Test commands
9. Supplemental script commands
10. Cleanup and dependency installation

## 10. Compressed handoff summary for future agents

If another agent needs a short briefing, this README style already provides:

- the domain model
- the input contracts
- the public commands
- the expected outputs
- the test surface
- the supplemental workflows

That makes it an excellent handoff artifact.

## Summary

The strongest README pattern here is concrete operational clarity. It explains the domain, shows exact inputs, gives runnable commands, documents outputs, and covers testing plus maintenance. That is the kind of README that remains useful even when the original authors are not present.
