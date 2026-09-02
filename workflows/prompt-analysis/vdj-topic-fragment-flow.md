# V(D)J Topic-Fragment Flow

```mermaid
flowchart TD
    A["User input: V(D)J recombination"] --> B["AGENTS.md: read the router and preserve server files"]
    B --> C["Prompt Analysis overview: load the gate and readiness rubric"]
    C --> D["Question Quality Assessment: classify as a topic fragment"]
    D --> E{"All rubric fields present?"}
    E -->|No| F["Do not research, explain, code, or use tools"]
    F --> G["Ask three V(D)J questions: focus; system/context; desired depth"]
    G --> H["Normalize: goal, context and scope, constraints, expected output"]
    H --> I{"Rubric passes?"}
    I -->|No| G
    I -->|Yes| J["AGENTS.md: route scientific work to Literature Review"]
    J --> K["Literature Review overview: select relevant evidence and explanation skills"]
    K --> L["Answer the clarified request"]
```

Relevant files: `AGENTS.md`, `overview.md`, `workflow.md`, `skills/prompt-readiness-rubric.md`, `skills/question-quality-assessment.md`, `skills/clarification-and-normalization.md`, and `../literature-review/overview.md`.
