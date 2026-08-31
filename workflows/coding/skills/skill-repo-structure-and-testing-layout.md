# INFO

This skill teaches an AI assistant how to structure a reusable code repository so public entrypoints, reusable modules, and tests are easy to discover and maintain.

The focus is on keeping the high-level flow obvious while pushing real logic into focused reusable modules and maintaining a clear split between unit tests and integration tests.

# Skill: Repo Structure And Testing Layout

## Purpose

Use this skill when designing or refactoring the high-level shape of a script-heavy or pipeline-style repository.

## Core Idea

The structure is strongest when it separates:

- orchestration
- computational logic
- supplemental workflows
- unit tests
- integration tests

## Recommended Layout

```text
project/
├── README.md
├── ok-seq.sh
├── main_pipeline.py
├── new_wrapper.py
├── combine_images.py
├── data_validator.py
├── utils/
│   ├── file_type.py
│   ├── interpolation.py
│   ├── loaddata.py
│   ├── log.py
│   ├── processing_termination.py
│   ├── processing_transforms.py
│   ├── regions.py
│   └── signals.py
├── supplemental/
│   ├── zone_process.py
│   ├── decompose_process.py
│   └── tlx_to_bed.py
└── test/
    ├── integration_test.py
    ├── test_area_under.py
    ├── test_file_type.py
    ├── test_interpolation.py
    ├── test_loaddata.py
    ├── test_regions.py
    └── test_signals.py
```

## Core Rules

### 1. Keep public entrypoints obvious

The top-level files should make the user-facing interface easy to locate.

### 2. Keep orchestration thin

Top-level scripts should mostly:

- parse inputs
- initialize logging
- choose methods
- loop over datasets
- call downstream functions

### 3. Keep computation in reusable modules

Core logic should live in modules like:

- `regions.py`
- `signals.py`
- `interpolation.py`
- `processing_termination.py`
- `processing_transforms.py`

### 4. Isolate supplemental workflows

Example:

```text
supplemental/
├── zone_process.py
├── decompose_process.py
└── tlx_to_bed.py
```

### 5. Separate unit and integration tests

Example unit layer:

```text
test/
├── test_area_under.py
├── test_file_type.py
├── test_interpolation.py
├── test_loaddata.py
├── test_regions.py
└── test_signals.py
```

Example integration layer:

```text
test/
└── integration_test.py
```

### 6. Run the real public interface in integration tests

Example:

```python
command = [
    "sh", "ok-seq.sh",
    "-bed", "test/test_data/integration_test_folder/correct_number_points/test_bed.12282024.bed",
    "-bdg", "test/test_data/integration_test_folder/correct_number_points/U2OS_DMSO.20250108.RFD.smooth_each_side_30kb.bdg",
    "--method", "zone",
    "--out", "test/test_run",
    "--defaults", "[0.15,10,0.08]"
]

result = subprocess.run(command, check=True, text=True, capture_output=True)
```

Then verify real generated outputs:

```python
combined_regions_df = pd.read_csv("test/test_run/csv_files/test_bed_12282024/test_bed_12282024_all_genes_combined_regions.csv")
assert combined_regions_df["Fork Max"][0] == 0.9
```

### 7. Put representative domain edge cases into unit tests

Good partitions include:

- start outside / end outside
- start inside / end inside
- always above threshold
- always below threshold
- interpolated crossing
- confidence-sensitive classification

## Short Checklist

1. Are public entrypoints easy to find?
2. Is orchestration thin?
3. Is core computation reusable?
4. Are unit and integration tests separated?
5. Do integration tests hit the real interface?
