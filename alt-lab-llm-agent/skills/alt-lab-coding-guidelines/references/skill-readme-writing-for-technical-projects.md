# INFO

This skill teaches an AI assistant how to write a technical README that gives future users enough context to understand the project and enough commands to use it immediately.

The focus is on concrete operational clarity: what the project does, what it needs, how to run it, what it produces, and how to test it.

# Skill: README Writing For Technical Projects

## Purpose

Use this skill when creating or revising a README for a script-heavy, pipeline-style, or technical repository.

## Core Idea

A strong README should answer these questions quickly:

- What problem does this project solve?
- What are the main operating modes?
- What inputs are required?
- What commands should I run first?
- What outputs should I expect?
- How do I run tests?
- What supporting scripts exist?

## Core Rules

### 1. Start with domain context before setup instructions

Example style:

```text
OK-seq data comes in the form of a signal-like graph with RFD as the Y-axis and genomic coordinate as the X-axis.
The pipeline analyzes this wave-like data by determining when the signal has meaningfully crossed a boundary and
quantifies those regions into zones.
```

Why this is strong:

- the reader understands purpose before commands
- future agents get the domain model early

### 2. Explain major operating modes clearly

If a repo has multiple methods, explain both the purpose and the difference.

Example:

- `zone`: classify initiation and termination behavior from the signal
- `decompose`: estimate a threshold boundary from signal decomposition

### 3. Show exact input formats

Example BED format:

```text
chr1    1000    1100    DLG2
chr1    1100    1200    MACROD2
chr1    1200    1300    PCDH15
```

Example BDG format:

```text
chr1    1000    1100    0.0
chr1    1100    1200    0.31
chr1    1200    1300    0.59
```

### 4. Include runnable quick-start commands

Example minimal run:

```bash
sh ok-seq.sh \
  -bed test/test_data/integration_test_folder/correct_number_points/test_bed.12282024.bed \
  -bdg test/test_data/integration_test_folder/correct_number_points/U2OS_DMSO.20250108.RFD.smooth_each_side_30kb.bdg \
  --method zone
```

### 5. Include a realistic advanced example

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

### 6. Document expected output structure

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

### 7. Include test commands explicitly

Example:

```bash
python3 -m pytest test/
python3 -m pytest test/test_area_under.py
python3 -m pytest test/test_file_type.py
python3 -m pytest test/test_regions.py
python3 -m pytest test/integration_test.py
```

### 8. Include maintenance commands carefully

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

Safety note:

- command examples are examples only
- do not execute them unless they are needed for the user’s current task
- commands that delete, overwrite, install, upload, modify permissions, or access remote systems require explicit approval

## Short Checklist

1. Does the README explain the domain before setup?
2. Are the main modes clear?
3. Are inputs and outputs shown concretely?
4. Are there runnable examples?
5. Are the test commands explicit?
