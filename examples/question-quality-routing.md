# Question Quality Routing

## Input

"What is known about RAG?"

## Expected Behavior

Route the request to Prompt Analysis because its purpose, scope, model system, depth, and expected output are unclear. Ask no more than three clarification rounds, normalize the answerable request, then route it to Literature Review.

## Acceptance Criteria

- The response does not begin broad literature research before clarification.
- The clarifying questions target decisions that would materially change the answer.
- The normalized request names the goal, scope, constraints, and expected output.
