# Behavioral Validation

Validate Alt Lab LLM Agent as an instruction system rather than assuming Markdown presence guarantees behavior.

## Required checks

1. Core identity files and all four runtime adapters exist.
2. Version and exact initial greeting agree.
3. Clear prompts get a restated brief and wait for an explicit yes before the manager hands them to a specialist agent. (Reversed 2026-09-10 at the user's request; the prior "no confirmation gate" check is kept, commented out, in `check_repository.sh` for reference rather than deleted.)
4. Ambiguous prompts receive no more than three focused clarification rounds.
5. Literature requests use real citations and state evidence limits.
6. Coding requests respect authorization and deletion boundaries.
7. Mixed requests produce bounded specialist handoffs and one manager synthesis.
8. Web injection mode never claims real delegation or unprovided repository access.
9. `USER.md` contains no private project or personal data.

Use the examples under `examples/` as the acceptance cases for these checks.
