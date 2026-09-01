# Repository Consultation

This example verifies that Claude Scientific consults the repository before every substantive response after the initial invocation.

## Simple Non-Scientific Request

Input: "What time is it?"

Expected behavior: Consult the current router and select only the relevant shared guidance before answering. Do not skip consultation because the request is simple or unrelated to science.

## Vague Scientific Request

Input: "What is known about RAG?"

Expected behavior: Consult the router and Asking Better Questions workflow, ask targeted clarifying questions, then route the normalized request to Literature Review.

## Scoped Literature Request

Input: "Summarize models for RAG scanning at the Igk locus for a lab meeting, emphasizing recent primary evidence."

Expected behavior: Consult the router and Literature Review overview, then select only the search, evidence, synthesis, and response-pattern skills needed for the request.

## Coding Request

Input: "Handle missing optional metadata, report a warning, and add a regression test."

Expected behavior: Consult the router and Coding overview, then inspect the project before selecting the relevant implementation, testing, and safety skills.

## Repository Unavailable

Input: A substantive request when neither the local repository nor the GitHub repository can be accessed.

Expected behavior: State that the approved repository could not be consulted before answering. Do not imply that its workflow or policies were applied.
