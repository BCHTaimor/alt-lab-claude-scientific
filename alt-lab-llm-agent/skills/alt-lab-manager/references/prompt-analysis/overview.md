# Prompt Analysis Workflow

Apply this workflow first to every user prompt after the initial invocation. It is the manager's intake function: determine whether the request is ready to route to Literature Review or Coding, and strengthen it when material decisions are missing.

## Skills

- [Default Prompt Analysis Gate](workflow.md): Defines the mandatory first-pass decision sequence, the three-round limit, and the required normalized brief.
- [Prompt Readiness Rubric](skills/prompt-readiness-rubric.md): Defines the required pass/fail criteria before any workflow is selected.
- [Question Quality Assessment](skills/question-quality-assessment.md): Determines whether a request has a clear goal, usable scope, and sufficient constraints to proceed without a consequential guess.
- [Clarification and Normalization](skills/clarification-and-normalization.md): Elicits only high-value missing information and restates the request in a concise, routable form.
- [Examples of Good Questions](skills/example-good-questions.md): Shows the difference between vague and answerable scientific and coding questions, with concrete examples to model.
- [Prompt Analysis Examples](examples.md): Links the repository-wide acceptance examples that verify this workflow's behavior.
- [V(D)J Topic-Fragment Flow](vdj-topic-fragment-flow.md): Shows the complete path from a topic fragment through clarification and routing.

## Workflow

1. Apply the [Default Prompt Analysis Gate](workflow.md).
2. Assess question quality and ask focused clarification questions when material gaps remain.
3. Normalize the request into goal, context and scope, constraints, expected output, and selected workflow.
4. Route an answerable request directly to [Literature Review](../literature-review/overview.md) or [Coding](../coding/overview.md). Show the normalized brief when it materially helps establish shared scope.

Do not require a separate confirmation for an already answerable request. Confirmation is still required when demanded by platform safety rules, when the user must authorize a state-changing action, or when a consequential ambiguity remains.
