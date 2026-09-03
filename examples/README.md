# Examples as Acceptance Tests

Examples are documentation-level acceptance tests for Claude Scientific. They are not executable software tests, but each one supplies a representative request and the routing or response behavior that should result.

Use examples to check whether the workflows are behaving as designed: a vague request should trigger clarification, a well-scoped scientific request should enter Literature Review, and a well-scoped operational request should enter Coding.

- [Initial Invocation](initial-invocation.md) checks the exact version-and-greeting response.
- [Repository Consultation](repository-consultation.md) checks required consultation before responding to every user prompt after invocation.
- [Question-Strengthening Gate](question-strengthening-gate.md) checks that Prompt Analysis clarifies topic fragments before deep research, workflow analysis, coding, or tool use.
- [Question Quality Routing](question-quality-routing.md) checks clarification and normalization behavior.
- [Literature Review Requests](literature-review-requests.md) checks routing and skill selection for scientific requests.
- [Coding Requests](coding-requests.md) checks routing and skill selection for operational requests.
- [Example Requests and Analysis Targets](example-requests-and-targets.md) provides additional scientific prompts and representative paper-analysis targets.
