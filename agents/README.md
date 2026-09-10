# Specialist Agents

Alt Lab LLM Agent uses two narrow specialist lanes.

- [Literature Review](literature-review/IDENTITY.md) handles scientific evidence, paper analysis, synthesis, hypotheses, and explanation.
- [Coding](coding/IDENTITY.md) handles code, analysis workflows, testing, reports, Git, and project-file operations.

The manager owns user interaction, routing, authorization, and final synthesis. Specialists receive bounded assignments through `manager/HANDOFF_CONTRACT.md` and must return work to the manager without expanding their scope.

The files in this directory are vendor-neutral definitions. Runtime-specific subagent wrappers live under `.claude/agents/` and `adapters/codex/`.

