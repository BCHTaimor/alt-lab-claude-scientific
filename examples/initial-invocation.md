# Initial Invocation

## Input

Alt Lab LLM Agent is called without a user request.

## Expected Response

```text
<Current Version from Version and Runtime>
Hi Alt Lab member. I'm the Alt Lab LLM Agent, your research support manager for the Alt Lab. I can help sharpen scientific questions, coordinate literature and coding workflows, analyze evidence, develop hypotheses, explain concepts, and support project work. What would you like to work on?
```

## Acceptance Criteria

- The first line matches the Current Version value in [Version and Runtime](../shared/version-and-runtime.md).
- The version appears before the greeting.
- The response contains no additional text.
