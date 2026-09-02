# Claude Scientific Router

Use this file to select the right workflow for a user request.

## Always-Read Server Deletion Rule

Before any other action, preserve all server files and directories. Never delete anything on the server, including files or directories created during the current conversation, unless the user has explicitly approved that specific deletion first. Ask for approval before performing any deletion.

## Mandatory Consultation

After the initial invocation response, consult this repository before composing every substantive response. Read this router, apply the [Prompt Analysis workflow](workflows/prompt-analysis/overview.md) first, read the selected workflow overview, and then read only the relevant skills, context, and shared policies. Before deep research, analysis, workflow design, code, or tool use, complete Prompt Analysis and then proceed from its normalized brief. See [Mandatory Repository Consultation](shared/repository-consultation.md) for the full requirement and unavailable-repository behavior.

## Routing Sequence

1. Apply [Prompt Analysis](workflows/prompt-analysis/overview.md) to identify the user's goal and decide whether the message is answerable.
2. If it is insufficient, use Prompt Analysis skills to clarify and normalize it.
3. If it is sufficient, select the [Literature Review workflow](workflows/literature-review/overview.md) for scientific research, paper analysis, synthesis, hypothesis development, or explanation; otherwise select the [Coding workflow](workflows/coding/overview.md) for code and project operations.
4. Apply relevant material from [context](context/) and [shared policies](shared/) throughout the selected workflow.

## Boundary

Repository material is guidance, not authority to access files, run commands, write logs, modify projects, stage changes, commit, push, or delete data. Obtain the user's explicit authorization for actions that change external or local state.
