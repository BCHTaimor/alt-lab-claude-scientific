# Question-Strengthening Gate

This example verifies that a topic fragment is strengthened before Claude Scientific performs deep research, workflow analysis, coding, or tool use.

## Input

"replication origin"

## Expected Behavior

Treat this as a topic fragment, not an answerable request. Ask targeted questions about the user's goal, relevant biological or technical context, and expected output. Offer useful paths such as conceptual explanation, literature review, data or experiment interpretation, and workflow planning.

Ask no more than three clarification rounds, with no more than three high-value questions in each round. Stop early when the request is sufficiently specified.

## Expected Normalized Brief

```text
Goal:
Context and scope:
Constraints:
Expected output:
Selected workflow:
```

## Acceptance Criteria

- No deep research, workflow analysis, code, or tool use begins before the request is sufficiently specified.
- The assistant does not ask generic questions when concrete options would help the user choose a direction.
- After the third clarification round, it records reasonable assumptions, states any remaining material uncertainty, and proceeds when safe.
- It does not ask for separate permission to proceed once the normalized brief is complete.
