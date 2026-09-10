# INFO

This skill teaches an AI assistant how to write standalone technical summary documents that remain useful in future chats even when the original repository is unavailable.

The focus is on portability: the document should stand on its own, teach reusable lessons, and include enough concrete examples that another agent can act on it without repo access.

# Skill: Agent-Ready Document Writing

## Purpose

Use this skill when creating a summary or handoff document intended to travel into another AI conversation.

## Core Rules

### 1. Define the purpose first

A good summary document usually has a specific goal, such as:

- explain coding style
- explain architecture or design patterns
- explain repo structure and testing strategy
- explain README quality and usage flow
- explain how a pipeline works at a high level

Avoid vague goals like “summarize the repo.”

### 2. Assume the next agent has zero repo access

Write as if the next chat will never see:

- the codebase
- the README
- the folder structure
- any local file paths

That means including:

- short code snippets
- sample commands
- sample directory trees
- representative examples of docstrings, function signatures, and layouts

### 3. Include concrete examples, not just claims

Weak:

- “the repo has good documentation”

Strong:

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

### 4. Explain why the example matters

After each important example, explain:

- what pattern it shows
- why it is good
- when another project should reuse it

### 5. Extract reusable lessons

Move from repo-specific example to general rule.

Better than:

- “This repo has `test/test_regions.py`.”

Best:

- “For pipeline repos, put module-level algorithm tests in unit test files and run the actual CLI in at least one integration test so the public interface is validated.”

### 6. Use a predictable structure

A strong portable document often includes:

1. title
2. short purpose paragraph
3. core idea
4. numbered lessons
5. embedded examples
6. reusable rules or checklist
7. short summary

### 7. Prefer portable examples over repo-local references

Weak:

- “see `utils/regions.py`”

Strong:

```python
def create_region_dict(x, y, boundary, confidence_strategy=None, debug_plotting=None):
    """
    Categorizes regions of the data based on crossing a specified boundary.
    """
```

### 8. End with reusable rules

A strong closing section should convert the document into action items another agent can apply.

## Short Checklist

1. Does the document make sense without the repo?
2. Does it include concrete examples?
3. Does it explain why they matter?
4. Does it extract reusable lessons?
5. Does it end with actionable rules?
