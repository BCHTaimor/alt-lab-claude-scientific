# INFO

This skill teaches an AI assistant how to write Python with explicit contracts, strong docstrings, documented invariants, and side effects that are obvious to future readers.

It is intended for general technical repositories, especially ones where clarity and maintainability matter more than minimalism.

# Skill: Python Contract And Docstring Writing

## Purpose

Use this skill when writing or revising Python code for a repository that should remain understandable to future developers and agents.

The goal is to produce code that explains what it does, what it takes, what it returns, and what assumptions it relies on without requiring outside explanation from the original author.

## Core Rules

### 1. Write docstrings like lightweight specifications

A strong function docstring should explain:

- what each parameter means in domain terms
- what the function returns
- whether the function writes files or mutates state
- any important behavior rules or special cases

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

Why this is strong:

- it makes the side effect explicit
- it explains what the parameters mean rather than only what type they are
- it tells a future reader that the function is an output-producing pipeline step, not a pure transform

### 2. Document algorithmic behavior directly

When a function performs classification, interpolation, thresholding, segmentation, or similar logic, the docstring should explain those rules directly.

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

Why this is strong:

- it documents the returned structure
- it defines the classification vocabulary
- it records the semantic special cases of the algorithm

### 3. Avoid mutable default arguments

Do not use defaults such as:

```python
debug_plotting=[]
```

Use `None` and initialize inside the function:

```python
if debug_plotting is None:
    debug_plotting = []
```

This prevents cross-call state leakage.

### 4. Use class docstrings to define abstractions and invariants

When a class represents a schema, filename pattern, parser, or other constrained object, document:

- the abstraction function
- the representation invariant
- protection from representation exposure

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

This makes the contract visible instead of implicit.

### 5. Validate constructed outputs immediately

If a function generates filenames or identifiers, validate them at construction time.

Example:

```python
def generate_filename(self, gene, date, cell_line, treatment, start, end, category):
    file_name = f"{gene}_{date}_{cell_line}_{treatment}_{start}_{end}_{category}.png"
    if not self.validation_function(file_name):
        self.debug_self(file_name)
        raise ValueError(f"No match found for pattern {self.pattern} in text {file_name}")
    return file_name
```

Why this is strong:

- invalid outputs fail early
- debugging remains close to the failure site
- invariants are enforced rather than assumed

### 6. Use abstract interfaces when multiple implementations share one contract

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

This is useful when multiple strategies should satisfy one shared public contract.

## Recommended Output Style

When applying this skill, generated Python should usually have:

- descriptive function names
- complete docstrings on nontrivial public functions
- explicit side-effect descriptions
- `None`-based optional defaults
- class invariants when constrained state matters
- validation close to construction

## Short Checklist

1. Does every important function explain its behavior in domain terms?
2. Are side effects stated explicitly?
3. Have mutable defaults been avoided?
4. Are invariants documented where relevant?
5. Would a future developer understand the code without extra explanation?
