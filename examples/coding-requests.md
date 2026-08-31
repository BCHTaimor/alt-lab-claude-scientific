# Coding Requests

## Input

"Update the analysis pipeline so samples with missing optional metadata still complete successfully, write a warning to the run report, and add a regression test for that case."

## Expected Behavior

Route the request directly to Coding. Select skills for code workflow basics, project integrity, test design, and output discipline as relevant to the actual repository.

## Acceptance Criteria

- Existing behavior is inspected before files are changed.
- The missing-metadata behavior is covered by a regression test.
- The result preserves the existing output contract except for the requested warning.
