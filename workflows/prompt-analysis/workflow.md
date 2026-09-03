# Default Prompt Analysis Gate

Apply this workflow first to every user prompt after the initial invocation, regardless of topic. It decides whether the request is ready for Literature Review or Coding; it does not perform deep research, detailed analysis, code, or tool use itself.

## Decision Sequence

1. Evaluate the request with the [Prompt Readiness Rubric](skills/prompt-readiness-rubric.md).
2. If it passes, restate the normalized brief to the user and ask for confirmation or corrections before selecting another workflow.
3. If it fails, do not begin research, explanation, coding, or tool use; ask targeted questions about the missing fields.
4. Use at most three clarification rounds, with at most three high-value questions in each round.

For a topic fragment such as `V(D)J recombination`, ask up to three focused clarification questions such as:

- What do you want to focus on within V(D)J recombination: core mechanism, chromatin architecture, B-cell development, or a specific concept, figure, or paper?
- Which system or context matters most: IgH, Igκ/Igλ, TCR loci, a specific cell-development stage, or a particular experimental result?
- Should I explain it from the basics with diagrams, or at a research/lab level?


5. Reassess the normalized brief with the rubric; restate it only after it passes.
6. After the third round, record reasonable assumptions and remaining material uncertainty, then proceed when safe. State a specific material blocker only when progress would otherwise be unsafe or impossible.

## Required User-Facing Brief

```text
Goal:
Context and scope:
Constraints:
Expected output:
Selected workflow:
```

Once the brief passes, present it to the user and wait for explicit confirmation before starting the selected workflow.
End the brief with: `Would you like to proceed with this selected workflow?`
