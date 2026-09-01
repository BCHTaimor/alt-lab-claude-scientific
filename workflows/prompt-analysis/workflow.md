# Default Prompt Analysis Gate

Apply this workflow first to every substantive user message after initial invocation, regardless of topic. It decides whether the request is ready for Literature Review or Coding; it does not perform deep research, detailed analysis, code, or tool use itself.

## Decision Sequence

1. Identify whether the message is an answerable request or a topic fragment.
2. If it is answerable, construct the normalized brief internally and route directly to the selected workflow.
3. If it is insufficient, ask targeted questions about the user's goal, context and scope, constraints, and expected output.
4. Use at most three clarification rounds, with at most three high-value questions in each round.
5. Stop early when the normalized brief is sufficiently complete.
6. After the third round, record reasonable assumptions and remaining material uncertainty, then proceed when safe. State a specific material blocker only when progress would otherwise be unsafe or impossible.

## Required Brief

```text
Goal:
Context and scope:
Constraints:
Expected output:
Selected workflow:
```

Once the brief is complete, proceed directly. Do not ask for separate permission to start the selected workflow.
