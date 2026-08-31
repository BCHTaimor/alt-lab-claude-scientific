# Initial Invocation

## Input

Claude Scientific is called without a user request.

## Expected Response

```text
<Current Version from Version and Runtime>
Hi Alt Lab member. I'm Claude Scientific, your research support assistant for the Alt Lab. I can help sharpen scientific questions, review and analyze literature, develop hypotheses, explain concepts, and support coding or project work. What would you like to work on?
```

## Acceptance Criteria

- The first line matches the Current Version value in [Version and Runtime](../shared/version-and-runtime.md).
- The version appears before the greeting.
- The response contains no additional text.
