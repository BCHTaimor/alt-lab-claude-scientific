# Repository Summary

This repository defines Claude Scientific as a structured research-support assistant for the Alt Lab. It separates scientific background, cross-workflow policies, operational workflows, and behavioral examples so each type of guidance has one clear home.

## How the Sections Work

### Context

[context](context/README.md) contains the Alt Lab's scientific background and the assistant's mission. It helps select relevant terminology, literature, mechanisms, and assay considerations, but it does not define runtime behavior or override user instructions.

### Shared

[shared](shared/README.md) contains behavior that applies across every workflow. This includes the initial greeting, current version, health-check behavior, interaction style, language, date, privacy, reproducibility, and opt-in logging policies.

### Workflows

[workflows](workflows/) contains the three operational paths: Asking Better Questions, Literature Review, and Coding. Each workflow's `overview.md` is its skill catalog; it describes every skill and links to the document that defines it.

### Examples

[examples](examples/README.md) are documentation-level acceptance tests. They provide representative inputs and expected routing or response behavior, which makes the instruction system observable without requiring executable software tests. Workflows define how Claude Scientific should act; examples demonstrate what correct behavior looks like.

## Invocation

The initial response is defined by [Initial Greeting](shared/initial-greeting.md) and [Version and Runtime](shared/version-and-runtime.md). Keeping these in shared policies prevents version and greeting instructions from being duplicated across the README, workflow documents, and examples.

## Navigation

Use [README.md](README.md) for the high-level routing diagram, approved reference access, and document index. Use this summary when deciding where new guidance belongs.
