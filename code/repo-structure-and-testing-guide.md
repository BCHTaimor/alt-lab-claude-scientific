# Repo Structure And Testing Guide For Reusable Pipelines

This guide captures a repository structure that works well for analytical pipelines and scientific Python projects. It is written to be useful even when the original repository is unavailable.

## Core idea

The structure is effective because it keeps the user-facing entrypoints simple while pushing the real computation into focused utility modules. It also separates:

- orchestration
- computational logic
- supplemental workflows
- unit tests
- integration tests

## 1. Recommended high-level layout

A strong layout looks like this:

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

Why this works:

- the public entrypoints are near the top
- reusable computational logic is centralized in `utils/`
- non-primary workflows live in `supplemental/`
- tests are easy to discover

## 2. Execution should flow through a clear funnel

A good pipeline structure has an obvious top-down execution path:

1. A shell wrapper parses arguments and sets environment details.
2. A Python entrypoint initializes logging and shared state.
3. A validator/loader stage checks inputs and loads data.
4. A wrapper/orchestrator loops through datasets and calls the core processing code.
5. A final aggregation step combines results into user-facing artifacts.

Example:

```python
if __name__ == "__main__":
    print("started pipeline")
    print("started data validator")
    data_validator_main(...)
    print("running the wrapper")
    wrapper_main()
    print("combining the generated images")
    combine_images_main()
```

This flow is good because another agent can quickly locate:

- where inputs enter
- where validation happens
- where computation happens
- where outputs are assembled

## 3. Keep orchestration thin and computation deep

The strongest structural choice is to keep top-level scripts thin.

Top-level files should mostly:

- parse inputs
- log progress
- choose methods
- loop over datasets
- call downstream functions

Core logic should live in modules like:

- `regions.py`
- `signals.py`
- `interpolation.py`
- `processing_termination.py`
- `processing_transforms.py`

This separation improves:

- readability
- testability
- reuse
- agent navigation speed

## 4. Put support or exploratory workflows in a separate folder

It is useful to isolate debugging and supplemental scripts:

```text
supplemental/
├── zone_process.py
├── decompose_process.py
└── tlx_to_bed.py
```

Why this is a good pattern:

- the main pipeline stays uncluttered
- exploratory scripts still live in the repo
- secondary workflows are available without being confused for the primary interface

This is especially helpful in research code where useful side scripts naturally accumulate.

## 5. Split tests into unit and integration layers

A strong testing layout distinguishes between:

- unit tests for focused algorithms
- integration tests for public workflows

Example unit test set:

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

Why this matters:

- unit tests catch algorithmic regressions quickly
- integration tests catch broken CLI wiring, output paths, and end-to-end behavior

## 6. Good integration tests run the real public interface

A particularly strong testing habit is to run the actual CLI entrypoint inside integration tests.

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

Then verify generated artifacts:

```python
combined_regions_df = pd.read_csv("test/test_run/csv_files/test_bed_12282024/test_bed_12282024_all_genes_combined_regions.csv")
assert combined_regions_df["Fork Max"][0] == 0.9
```

Why this is strong:

- it exercises the shell wrapper
- it exercises the Python orchestration
- it verifies real outputs rather than only internal return values

## 7. Put representative domain edge cases into unit tests

Strong unit tests should cover meaningful partitions of the domain logic.

Example from region-classification style tests:

- start outside / end outside
- start inside / end inside
- always above threshold
- always below threshold
- interpolated low-to-high crossing
- confidence-sensitive classification

That kind of partitioning is much better than only testing a couple happy paths.

Example shape:

```python
def test_create_region_dict_start_outside_end_outside():
    x = np.array([0, 0.5, 1, 2, 5, 6, 7])
    y = np.array([-2, 0, 1, 2, 1, 0, -2])
    boundary = calc_noise_data(x, y)
    result, _ = create_region_dict(x, y, boundary)
    assert len(result) == 3
```

## 8. Example command surface to preserve in future repos

A well-structured repo should make these commands obvious:

Run the full test suite:

```bash
python3 -m pytest test/
```

Run one unit test module:

```bash
python3 -m pytest test/test_regions.py
```

Run the integration suite:

```bash
python3 -m pytest test/integration_test.py
```

Run a supplemental script:

```bash
python3 -m supplemental.zone_process
python3 -m supplemental.decompose_process
```

Run the main pipeline:

```bash
sh ok-seq.sh \
  -bed /path/to/test.bed \
  -bdg /path/to/test.bdg \
  --method zone
```

## 9. Structural rules worth reusing

If you want another repo to feel like this one, keep these rules:

1. One clear public CLI path.
2. One Python orchestrator behind that CLI.
3. Core computations in utility modules.
4. Supplemental workflows in their own folder.
5. Unit tests named by module.
6. At least one integration test that runs the real entrypoint.
7. Output directories and filenames predictable enough to assert in tests.

## Summary

This structure is strong because it keeps the surface area simple for users while preserving clean modularity for contributors and future agents. The best parts are the thin orchestration layer, focused `utils/` modules, isolated supplemental scripts, and the split between unit and integration testing.
