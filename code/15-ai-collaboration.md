# AI Collaboration

Before starting work, an AI agent should:

1. Read this AGENTS.md.
2. Read README.md if present.
3. Restrict all inspection to the project directory explicitly provided by the user.
4. Default to read-only inspection until the user requests a specific modification.
5. Review the latest report only if it is relevant to the requested task.
6. Review the latest workflow only if it is relevant to the requested task.
7. Check Git history only if version history matters for the requested task.
8. Inspect current project status only to the minimum extent needed for the requested task.

Before finishing work, an AI agent should:

1. Modify only the files necessary for the user's explicitly requested task.
2. Identify the target files before editing them whenever practical.
3. Update workflow documentation only when the task changes the workflow.
4. Generate or update an analysis report only when the user requested reporting or the repo workflow clearly requires it for the requested task.
5. Preserve reproducibility.
6. Do not leave undocumented temporary files.
7. Do not delete, move, rename, or overwrite existing files without explicit approval.
