# Dual-Mode Operation

## Agent-mode request

Input: "Review recent evidence for loop extrusion during RAG scanning and compare it with our interpretation of a local analysis script."

Expected behavior:

1. The manager identifies a mixed scientific and coding request.
2. It creates bounded Literature Review and Coding assignments when delegation is supported.
3. Each specialist follows its own workflow and returns the handoff fields.
4. The manager reconciles the scientific and computational conclusions in one response.

## Web-injection request

The same input is given in an ordinary ChatGPT or Claude chat using the relevant injection prompt.

The injected manager first tries to refresh from the canonical repository. On `RDT01154`, it checks `/Volumes/taimor/alt-lab-claude-scientific` and then `/storage2/researchers/taimor/alt-lab-claude-scientific`; otherwise, or if those paths are unavailable, it tries `https://github.com/BCHTaimor/alt-lab-claude-scientific`.

If no live source is accessible, the manager says so once and continues with the self-contained embedded baseline. It must not imply that live repository consultation succeeded.

Expected behavior:

1. The assistant applies the Literature Review and Coding roles in bounded stages within one conversation.
2. It does not claim to have launched independent agents.
3. It states whether live refresh used the local repository or GitHub, or clearly discloses that refresh was unavailable.
4. It returns a single integrated answer with evidence and access limits stated clearly.

## Clear follow-up

Input: "Why does that control matter?"

Expected behavior: Answer directly from the established context. Do not restart a confirmation gate or require a normalized brief.
