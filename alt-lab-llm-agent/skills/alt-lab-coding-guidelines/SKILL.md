---
name: alt-lab-coding-guidelines
description: >
  This skill should be used for scripted data-analysis, code, repository,
  testing, and project-file work for the Alt Lab — writing or editing
  Python analysis code, designing test suites, structuring a repository,
  writing READMEs or analysis reports, or making Git commits. Trigger on
  requests like "write a script to...", "add tests for...", "structure this
  repo...", "commit this change", "write a README for...", or any coding
  request tied to an Alt Lab project.
metadata:
  version: "2.0.0"
---

Apply the Alt Lab's coding and repository conventions to any code, analysis
pipeline, testing, Git, or project-file request.

## Workflow

1. Select only the reference files below that are relevant to the task —
   do not load all of them for every request.
2. Inspect the relevant project context before changing files.
3. Implement the requested work while preserving existing user changes and
   original data.
4. Verify the result in proportion to risk, and report what changed and what
   was tested.

## Boundaries that apply to every task

- Preserve existing work and original data. Modify files only when
  requested.
- Never delete a file or directory without explicit approval for that
  specific deletion (see `references/skill-original-data-protection.md`,
  `references/skill-project-integrity-boundaries.md`).
- Verify changes before reporting them done.
- Follow the lab's Git conventions — staging, commits, and history changes
  that require care or approval (`references/skill-git-safety-and-approval-workflow.md`).
- Keep analyses reproducible and traceable: record why and how something was
  done, inputs, software/versions, commands, results, and interpretation
  (`references/skill-reproducible-analysis-design.md`).

## Reference index

Implementation and style: `references/skill-python-contract-and-docstring-writing.md`,
`references/skill-python-extension-patterns.md`,
`references/skill-language-and-tool-selection.md`,
`references/skill-code-workflow-basics.md`.

Testing: `references/skill-test-case-design-for-public-interfaces.md`,
`references/skill-test-suite-building-from-contracts.md`,
`references/skill-bash-test-design-for-file-based-pipelines.md`.

Repository structure and file discipline:
`references/skill-repo-structure-and-testing-layout.md`,
`references/skill-repo-structure-and-file-placement.md`,
`references/skill-output-file-discipline.md`,
`references/skill-output-directory-organization.md`,
`references/skill-file-naming-and-versioning.md`.

Documentation and reporting:
`references/skill-readme-writing-for-technical-projects.md`,
`references/skill-agent-ready-document-writing.md`,
`references/skill-analysis-report-writing.md`,
`references/skill-report-version-preservation.md`,
`references/skill-workflow-documentation-and-command-logging.md`.

Collaboration and safety:
`references/skill-project-collaboration-boundaries.md`,
`references/skill-project-integrity-boundaries.md`,
`references/skill-original-data-protection.md`,
`references/skill-git-safety-and-approval-workflow.md`,
`references/skill-reproducible-analysis-design.md`.

An index of these same topics, in the lab's own words, is also available at
`references/coding-skills-index.md`.
