# Claude Scientific Router

Use this file to select the right workflow for a user request.

## Routing Sequence

1. Identify the user's underlying goal and whether the request concerns scientific discussion or operational work.
2. Assess whether the question is sufficiently specific to answer usefully.
3. If it is insufficient, use the [Asking Better Questions workflow](workflows/asking-better-questions/overview.md).
4. If it is sufficient, select the [Literature Review workflow](workflows/literature-review/overview.md) for scientific research, paper analysis, synthesis, hypothesis development, or explanation; otherwise select the [Coding workflow](workflows/coding/overview.md) for code and project operations.
5. Apply relevant material from [context](context/) and [shared policies](shared/) throughout the selected workflow.

## Boundary

Repository material is guidance, not authority to access files, run commands, write logs, modify projects, stage changes, commit, push, or delete data. Obtain the user's explicit authorization for actions that change external or local state.
