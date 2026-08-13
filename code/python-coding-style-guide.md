# Python Coding Style Guide Inspired By This Repo

This guide is meant to be reusable outside the original repository. It captures a Python style that is especially good for analytical, pipeline, and scientific code: clear contracts, explicit invariants, domain-aware naming, and docstrings that explain both what code does and how it does it.

## Core idea

The central style rule is this: code should explain its contract in the code itself.

That means:

- functions say what they take, what they produce, and whether they write files or mutate state
- classes explain what abstraction they represent
- important invariants are written down, not left implicit
- names reflect the problem domain, not just generic programming terminology

## 1. Write function docstrings like lightweight specifications

A strong function docstring in this style explains:

- what each parameter means in domain terms
- what the function returns
- whether the function has side effects
- any major behavioral rules or special cases

Example:

```python
def combine_images_all_genes(input_folder, output_folder, valid_genes, output_prefix, mode):
    """
    @param input_folder: Folder containing per-gene PNG files.
    @param output_folder: Folder where the combined image should be written.
    @param valid_genes: Gene keys that should be included.
    @param output_prefix: BED partition prefix for the output directory.
    @param mode: FileType used to validate candidate files.
    @returns: None. Writes one or more stacked summary images to disk.
    """
```

Why this is good:

- it makes the side effect explicit: this function writes files
- it explains what `mode` means instead of only saying its type
- it tells a future reader this function is an output-producing pipeline step, not a pure transformer

Reusable template:

```python
def some_function(arg1, arg2, arg3):
    """
    @param arg1: Domain meaning of the first input.
    @param arg2: Domain meaning of the second input.
    @param arg3: Domain meaning of the third input.
    @returns: Returned value, or note that this function writes files / mutates state.
    """
```

## 2. For complex analytical functions, document the behavior rules

When a function contains classification logic, interpolation logic, or special-case handling, the docstring should include those rules directly.

Example:

```python
def create_region_dict(
    x,
    y,
    boundary,
    confidence_strategy=None,
    debug_plotting=None,
):
    """
    Categorizes regions of the data based on crossing a specified boundary.

    @param x: np.array or list of x-coordinates of the data points.
    @param y: np.array or list of y-coordinates of the data points, representing the signal values.
    @param boundary: Float value that defines the threshold for categorizing regions.
                     Regions are determined by whether the y-values cross this boundary.

    @returns:
        A dictionary where:
            - Keys represent the region between two x-values as "start:end".
            - Values represent the category of the region.
        The interpolated points created.

    The regions are categorized as follows:
        - 'enter_low_exit_low'
        - 'enter_low_exit_high'
        - 'enter_high_exit_low'
        - 'enter_high_exit_high'

    Special cases:
        - If y-values remain consistently higher than the boundary within a region, it is categorized as 'always high'.
        - If y-values remain consistently lower than the boundary within a region, it is categorized as 'always low'.
    """
    if confidence_strategy is None:
        confidence_strategy = SimpleThresholdConfidence()

    if debug_plotting is None:
        debug_plotting = []
```

Why this is good:

- it documents the returned structure
- it documents the classification vocabulary
- it includes the special cases that define the algorithm’s semantics
- it avoids mutable default arguments that can leak state across calls

For scientific code, this is much better than a short docstring like `Compute regions from signal`.

## 3. Use class docstrings to explain the abstraction

If a class represents a specification, schema, parser, or constrained object, document:

- the abstraction function
- the representation invariant
- how representation exposure is prevented

Example:

```python
class FileType():
    """
    AF(pattern) => creates filenames and can validate if a file name matches a particular pattern.
                    Also generates names for files made form combining files that match the pattern

    Rep Invarient:
        filenames created by generate_filename() pass the validation_function():

    Protection From rep exposure():
        the field pattern is never exposed in any functions
    """
```

Why this is good:

- it tells readers what the object means conceptually
- it identifies the invariant that must remain true
- it makes encapsulation intentional rather than accidental

This is especially useful for classes that wrap regexes, schema rules, file naming conventions, or other internal representations.

## 4. Validate constructed outputs immediately

This style favors creating a value and then validating it right away.

Example:

```python
def generate_filename(self, gene, date, cell_line, treatment, start, end, category):
    file_name = f"{gene}_{date}_{cell_line}_{treatment}_{start}_{end}_{category}.png"
    if not self.validation_function(file_name):
        self.debug_self(file_name)
        raise ValueError(f"No match found for pattern {self.pattern} in text {file_name}")
    return file_name
```

Why this is good:

- invalid outputs fail at construction time
- the debugging path is close to the failure
- the invariant is enforced rather than assumed

This is a strong pattern whenever code generates filenames, SQL, configuration strings, or structured identifiers.

## 5. Use abstract base classes when multiple implementations share a contract

Example:

```python
from abc import ABC, abstractmethod

class ConfidenceStrategy(ABC):
    @abstractmethod
    def calculate_confidence(self, region_x_values, region_y_values, noise_amplitude_range):
        """
        @returns whether we think the region is C (Confident) or P (Putative)
        """
        pass
```

Then concrete subclasses implement the behavior:

```python
class SimpleThresholdConfidence(ConfidenceStrategy):
    def __init__(self, fork_max_minimum=0.15, minimum_points=10):
        self.fork_max_minimum = fork_max_minimum
        self.minimum_points = minimum_points

    def calculate_confidence(self, region_x_values, region_y_values, noise_amplitude_range):
        total_points = int(np.count_nonzero(np.abs(region_y_values) > noise_amplitude_range))
        max_fork = max(abs(region_y_values))

        if total_points >= self.minimum_points and max_fork > self.fork_max_minimum:
            return "C"
        return "P"
```

Why this is good:

- it defines the extension point clearly
- callers can rely on one stable interface
- new strategies can be added without rewriting the orchestration code

## 6. Prefer domain-explicit names

A notable strength of this style is naming variables after the problem domain:

- `boundary`
- `fork_max_minimum`
- `valid_genes`
- `region_x_values`
- `noise_amplitude_range`
- `output_prefix`

These names are better than generic names like:

- `threshold`
- `min_val`
- `items`
- `xvals`
- `prefix`

because they encode meaning, not just shape.

## 7. Be explicit about side effects in orchestration code

Workflow code should make it obvious when it:

- writes files
- logs progress
- loops over datasets
- orchestrates multiple processing stages

Example shape:

```python
def pipeline_main():
    print("started pipeline")
    print("started data validator")
    data_validator_main(...)
    print("running the wrapper")
    wrapper_main()
    print("combining the generated images")
    combine_images_main()
```

This style is simple, but it is easy to trace and easy for another agent to debug.

## 8. Recommended rules for future projects

If you want to reproduce this style in another codebase, use these rules:

1. Every nontrivial public function gets a docstring.
2. Every docstring explains domain meaning, not just Python types.
3. Functions that write files or mutate state say so explicitly.
4. Classes with constrained internal state document their invariants.
5. Constructed outputs are validated immediately.
6. Abstract base classes define extension points where multiple implementations are expected.
7. Names should reflect the scientific or business domain.

## 9. Compressed example set for future agents

Example of a good function contract:

```python
def load_signal(path):
    """
    @param path: Path to a tab-separated RFD signal file.
    @returns: Pandas DataFrame with chromosome, start, end, and value columns.
    """
```

Example of a good side-effect contract:

```python
def write_summary_csv(rows, output_path):
    """
    @param rows: List of summary dictionaries to serialize.
    @param output_path: File path where the CSV will be written.
    @returns: None. Writes the summary CSV to disk.
    """
```

Example of a good invariant-bearing class:

```python
class RegionLabel:
    """
    AF(code) => represents a region confidence/trend label in the analysis pipeline.

    Rep Invariant:
        code is one of {"C always high", "C always low", "P always high", "P always low"}

    Protection From rep exposure():
        callers receive validated labels, not direct mutable access to internal state
    """
```

## Summary

This style is best for codebases where correctness and interpretability matter. Its strengths are contract-oriented docstrings, explicit invariants, domain-aware naming, and immediate validation of generated outputs.
