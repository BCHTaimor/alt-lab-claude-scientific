# INFO

This skill teaches an AI assistant which coding skills to read before acting. It is the entry point for implementation, testing, documentation, repository organization, and safe collaboration work.

# Skill: Code Workflow Basics

## Purpose

Use this skill at the start of coding or repository-maintenance work to select the smallest set of detailed skills needed for the task.

Read the relevant linked skills before planning, writing, or modifying code. Do not load unrelated guidance merely because it exists.

## Workflow Selection

### Writing or changing a public function, method, command, or module API

1. Read [skill-python-contract-and-docstring-writing.md](skill-python-contract-and-docstring-writing.md) to define inputs, outputs, side effects, preconditions, invariants, and domain semantics.
2. Read [skill-python-extension-patterns.md](skill-python-extension-patterns.md) when extending an existing Python abstraction or integration point.
3. Read [skill-test-suite-building-from-contracts.md](skill-test-suite-building-from-contracts.md) before designing or changing its tests.
4. Read [skill-test-case-design-for-public-interfaces.md](skill-test-case-design-for-public-interfaces.md) when deciding public test targets, unit-test scope, or integration-test scope.

### Writing or revising tests

1. Read [skill-test-suite-building-from-contracts.md](skill-test-suite-building-from-contracts.md) first.
2. Read [skill-test-case-design-for-public-interfaces.md](skill-test-case-design-for-public-interfaces.md) for public functions, methods, classes, and command-line interfaces.
3. Read [skill-bash-test-design-for-file-based-pipelines.md](skill-bash-test-design-for-file-based-pipelines.md) for Bash scripts, generated files, directories, and exit-code behavior.
4. Read [skill-repo-structure-and-testing-layout.md](skill-repo-structure-and-testing-layout.md) when adding fixtures, test directories, or test-runner configuration.

The test workflow is contract-first: establish or update the implementation contract, derive partitions and boundaries, show the test matrix unless immediate implementation was requested, then implement the tests with the matrix recorded at the top of each relevant test file.

### Writing repository documentation

- Read [skill-readme-writing-for-technical-projects.md](skill-readme-writing-for-technical-projects.md) for a README or onboarding documentation.
- Read [skill-agent-ready-document-writing.md](skill-agent-ready-document-writing.md) for instruction documents intended to guide an AI assistant.
- Read [skill-analysis-report-writing.md](skill-analysis-report-writing.md) for analysis reports.
- Read [skill-report-version-preservation.md](skill-report-version-preservation.md) when preserving or versioning reports.

### Placing files or organizing repository outputs

- Read [skill-repo-structure-and-file-placement.md](skill-repo-structure-and-file-placement.md) before adding source files, scripts, configuration, or documentation.
- Read [skill-file-naming-and-versioning.md](skill-file-naming-and-versioning.md) before choosing artifact names or version labels.
- Read [skill-output-file-discipline.md](skill-output-file-discipline.md) and [skill-output-directory-organization.md](skill-output-directory-organization.md) before creating generated outputs or output folders.
- Read [skill-workflow-documentation-and-command-logging.md](skill-workflow-documentation-and-command-logging.md) when a workflow needs reproducible command records.

### Changing project state or collaborating with others

- Read [skill-project-integrity-boundaries.md](skill-project-integrity-boundaries.md) and [skill-project-collaboration-boundaries.md](skill-project-collaboration-boundaries.md) before modifying an existing project.
- Read [skill-original-data-protection.md](skill-original-data-protection.md) before handling original or sensitive data.
- Read [skill-reproducible-analysis-design.md](skill-reproducible-analysis-design.md) when designing an analysis workflow.
- Read [skill-language-and-tool-selection.md](skill-language-and-tool-selection.md) when choosing an implementation language or tool.
- Read [skill-git-safety-and-approval-workflow.md](skill-git-safety-and-approval-workflow.md) before staging, committing, branching, merging, pushing, or changing Git history.

## Minimal Selection Rule

Choose only the workflows that directly apply to the requested work. For example:

- A new Python function with tests uses the Python contract, test-suite builder, public-interface testing, and applicable project-safety skills.
- A Bash pipeline test uses the test-suite builder, Bash test design, testing layout, and applicable project-safety skills.
- A README-only change uses the README-writing, agent-ready-writing when relevant, and Git-safety skills if a commit is requested.

## When To Use This Skill

Use this skill when a user asks to write, modify, test, document, organize, review, or commit code and a workflow selection is needed.
