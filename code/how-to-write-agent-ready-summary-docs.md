# How To Write A Good Agent-Ready Summary Document

This guide explains how to create a document that can be dropped into a different AI conversation and still be useful even when the new chat has no access to the original repository.

That is the key requirement:

- the document must stand on its own
- it must not depend on local file access
- it must carry enough examples and explanation that another agent can reason from it directly

## 1. Define the purpose of the document first

Before writing, decide exactly what the document is for.

A good summary document usually has one of these goals:

- explain coding style
- explain architecture or design patterns
- explain repo structure and testing strategy
- explain README quality and usage flow
- explain how a pipeline works at a high level
- explain conventions another agent should copy

Bad goal:

- "summarize the repo"

Good goal:

- "explain how this repo writes strong function docstrings and invariant-bearing classes"
- "explain how this repo uses strategy injection and singleton state"
- "explain how this repo organizes unit and integration tests"

If the goal is vague, the output will also be vague.

## 2. Assume the next agent has zero repo access

Write the document as if the next chat will never see:

- the codebase
- the README
- the folder structure
- any local file paths

That means you should include:

- short code snippets
- sample commands
- sample directory trees
- representative examples of function signatures and docstrings
- brief explanations of why those examples are good

Do not rely on phrases like:

- "see the repo"
- "refer to this file"
- "as shown in the codebase"

Those are only useful if the next agent already has access.

## 3. Include concrete examples, not just claims

A weak document says:

- "the repo has good documentation"
- "the repo uses patterns well"

A strong document says:

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

Then explain:

- why this docstring is good
- what style rule it demonstrates
- how another project could copy the pattern

Another example:

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

This is much more useful than saying "the repo has good class abstractions."

## 4. Explain why the example matters

Do not stop at the example itself.

After every important example, explain:

- what the pattern is
- why it is good
- when another project should use it

Good structure:

1. Show example
2. Name the idea
3. Explain why it helps
4. Explain how to reuse it

Example:

```python
class ConfidenceStrategy(ABC):
    @abstractmethod
    def calculate_confidence(self, region_x_values, region_y_values, noise_amplitude_range):
        pass
```

Explanation:

- This is an abstract strategy interface.
- It separates confidence scoring from region segmentation.
- Another repo should use this pattern when multiple decision policies need the same calling contract.

## 5. Write the document around reusable lessons

A good agent-ready document should extract generalizable lessons from the source material.

Bad:

- "This repo has `test/test_regions.py` and `test/test_signals.py`."

Better:

- "This repo separates focused unit tests from end-to-end integration tests, which is a strong pattern for pipeline projects."

Best:

- "For pipeline repos, put module-level algorithm tests in unit test files and run the actual CLI in at least one integration test so the public interface is validated."

The document should move from example to principle.

## 6. Use a predictable structure

A very effective structure for these documents is:

1. Title
2. One-paragraph purpose
3. Core idea
4. Numbered sections for major lessons
5. Embedded examples
6. Reusable rules or checklist
7. Short summary

Example outline:

```text
# Python Coding Style Guide

Short purpose paragraph

## Core idea

## 1. Write docstrings like lightweight specs
example
explanation

## 2. Document class invariants
example
explanation

## 3. Use abstract interfaces for extension points
example
explanation

## Recommended rules

## Summary
```

That structure is easy for both humans and agents to scan.

## 7. Prefer portable examples over repo-local references

If you include only file references, the document becomes brittle.

Weak:

- "`utils/regions.py` shows dependency injection"

Strong:

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
    """
    if confidence_strategy is None:
        confidence_strategy = SimpleThresholdConfidence()

    if debug_plotting is None:
        debug_plotting = []
```

Then say:

- this demonstrates dependency injection through a strategy parameter

File references are optional supporting context. They should not carry the document.

## 8. Include commands and folder trees when structure matters

For repo structure or README guides, include concrete command examples and directory layouts.

Example command:

```bash
python3 -m pytest test/
python3 -m pytest test/integration_test.py
```

Example structure:

```text
project/
├── README.md
├── main_pipeline.py
├── utils/
├── supplemental/
└── test/
```

This matters because another agent can reuse the pattern even without the original files.

## 9. Distinguish between what is explicit and what is inferred

Be careful not to overclaim.

For example:

- if a repo clearly defines a `Strategy` interface, call it a strategy pattern
- if it only has a family of similar classes without a dedicated factory, do not confidently call it a factory pattern

Strong document behavior:

- say what is definitely present
- say what is only pattern-adjacent
- avoid turning loose structure into grand architecture

This makes the document more trustworthy.

## 10. End with reusable rules

A strong closing section should convert the whole document into action items another chat can apply.

Example:

```text
Recommended rules:
1. Every nontrivial public function gets a docstring.
2. Docstrings explain domain meaning, not just types.
3. Classes with constrained state document invariants.
4. Use strategy injection when scoring logic may vary.
5. Separate unit and integration tests.
6. Include runnable commands in the README.
```

This is often the highest-value part for future agent use.

## 11. A simple prompt you can give another chat

You can reuse this prompt with another repository:

```text
Create a standalone Markdown summary document for this repository that I can use in future AI chats where the repo itself will not be available.

Requirements:
- The document must be self-contained.
- Do not rely on file references alone.
- Include short code snippets, command examples, and sample folder structures where useful.
- Explain not just what the repo does well, but why the pattern is good and how another project could reuse it.
- Be precise about design patterns: only claim a pattern if it is really present.
- End with a short reusable rules/checklist section.
```

## 12. Checklist for a finished document

Before calling the document done, check:

- Does it make sense without the repo?
- Does it include concrete examples?
- Does it explain why those examples matter?
- Does it extract reusable lessons?
- Does it avoid overclaiming architecture?
- Does it end with actionable rules?

If the answer to any of those is no, the document is not yet portable enough.

## Summary

A good agent-ready summary document is not just a summary. It is a portable teaching artifact. It includes concrete examples, explains why they matter, generalizes them into reusable lessons, and stays understandable even when the original repository is completely absent.
