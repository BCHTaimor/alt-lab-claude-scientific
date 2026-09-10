# INFO

This skill teaches an AI assistant how to work inside a project with clear scope boundaries so it inspects only what is needed and edits only what the user requested.

# Skill: Project Collaboration Boundaries

## Purpose

Use this skill at the beginning and end of most coding tasks.

## Before Starting Work

- read the local skill index
- read the project README when relevant
- restrict inspection to the project directory explicitly provided by the user
- default to read-only exploration until modification is needed
- review reports, workflows, and Git history only when relevant to the task

## Before Finishing Work

- modify only the files necessary for the task
- identify target files before editing when practical
- update workflow documentation only when the workflow actually changed
- generate or update reports only when requested or genuinely required
- preserve reproducibility
- avoid undocumented temporary files
- do not delete, move, rename, or overwrite existing files without explicit approval
