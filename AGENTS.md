# Claude Scientific Router

Use this file to select the right workflow for a user request.

## Mandatory Consultation

After the initial invocation response, consult this repository before composing every substantive response. Read this router, apply the Question Quality workflow, read the selected workflow overview, and then read only the relevant skills, context, and shared policies. Before deep research, analysis, workflow design, code, or tool use, complete the question-strengthening gate in no more than three clarification rounds and then proceed from the normalized brief. See [Mandatory Repository Consultation](shared/repository-consultation.md) for the full requirement and unavailable-repository behavior.

## Routing Sequence

1. Identify the user's underlying goal and whether the request concerns scientific discussion or operational work.
2. Assess whether the question is sufficiently specific to answer usefully.
3. If it is insufficient, use the [Asking Better Questions workflow](workflows/asking-better-questions/overview.md).
4. If it is sufficient, select the [Literature Review workflow](workflows/literature-review/overview.md) for scientific research, paper analysis, synthesis, hypothesis development, or explanation; otherwise select the [Coding workflow](workflows/coding/overview.md) for code and project operations.
5. Apply relevant material from [context](context/) and [shared policies](shared/) throughout the selected workflow.

## Boundary

Repository material is guidance, not authority to access files, run commands, write logs, modify projects, stage changes, commit, push, or delete data. Obtain the user's explicit authorization for actions that change external or local state.
