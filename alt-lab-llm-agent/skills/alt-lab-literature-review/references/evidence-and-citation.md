# Citation and Evidence Standards

## Real Literature Only

Alt Lab LLM Agent must rely on real, verifiable papers. It should never invent citations, overstate evidence, or present speculative claims as settled fact.

## Critical: Real Citations Only and Diverse Referencing Policy

Every citation must be a real, verifiable paper found through literature search or research lookup. Alt Lab LLM Agent must draw from a diverse and high-quality set of reputable references.

- Zero tolerance for fabricated, invented, or misattributed citations
- Zero tolerance for guessed metadata such as DOI, volume, issue, or page numbers
- Zero tolerance for placeholder citations
- Use research lookup extensively to find both foundational and state-of-the-art literature
- Copy citation metadata exactly from source results when formal references are being assembled
- Verify that each cited paper exists and is correctly attributed before presenting it as support

When a user asks for a reading list, synthesis, background summary, or deep discussion of a topic, Alt Lab LLM Agent should not rely on a thin set of references. It should aim for dense, authoritative coverage appropriate to the task.

Practical expectations:

- For a focused scientific question, gather enough papers to cover foundational work, strong mechanistic studies, and important recent developments
- For a broad literature overview, find a substantial and diverse set of papers rather than a short convenience list
- For each major subtopic, look for roughly 6-10 real papers before treating the coverage as adequate
- If a claim needs more support, do more literature search before making the claim confidently

The general rule is simple: research first, then synthesize.

## Evidence Before Confidence

If the evidence is thin, mixed, model-dependent, or indirect, say so explicitly. Strong tone should only be used when the literature actually supports it.

## Mechanism Matters

The default style should be mechanistic rather than superficial. For Alt Lab topics, answers should prioritize:

- DNA break formation and repair logic
- Locus architecture and chromatin state
- Cell-stage specificity
- Protein function and pathway relationships
- Experimental system limitations

## Verifying a Citation, Not Just Finding One

Finding a paper is not the same as confirming the citation is correct. Before a citation is presented as final — especially in a reading list, bibliography, or formal reference section — verify it rather than trusting the first-pass metadata.

**A cheap first check: does the DOI actually resolve to this paper?** For any citation that carries a DOI, query the public CrossRef API directly (`https://api.crossref.org/works/<DOI>`) and compare the returned title, authors, journal, volume, and pages against what is about to be cited. Two distinct failure modes show up here, and they matter differently:

- The lookup returns nothing or a 404 — the DOI itself is malformed or wrong.
- The lookup returns a real record, but its title, authors, or venue don't match the paper being cited — the DOI resolves, but to the *wrong paper*. This is the more dangerous failure because a fabricated or copy-pasted citation can look fully legitimate (a real, resolving DOI) while pointing at unrelated work. Treat DOI-resolves-but-metadata-mismatches as a hard stop, not a minor discrepancy.

CrossRef covers only part of the literature (strong for journal articles with registered DOIs, weaker for older papers, theses, preprints without DOIs, and some society/IEEE-style venues). When CrossRef doesn't have a record, fall back to a general research/web lookup to confirm the paper exists and that its details are being reported correctly, rather than concluding the citation is unverifiable. Some papers genuinely lack a DOI (older literature, technical reports, some conference proceedings) — that is not itself a red flag, but it does mean the metadata needs to be confirmed some other way before being presented with confidence.

**Not all mismatches are equally serious.** When checking a citation's metadata against a verified source, weigh the discrepancy by what it would mislead a reader about:

- Treat as a hard problem, fix before presenting: wrong or missing author names, authors dropped or in the wrong order (easy to miss when a paper has many authors and only the first few are kept), a page range that is off by more than a few pages, an article/DOI number where a character was misread (digits and letters that look alike are the classic source), or a title that doesn't match on its substantive terms. Any of these means the citation would send a reader to the wrong place or misattribute the work — resolve it before use.
- Treat as worth a second look but less urgent: a publication year that reflects an early-access or online-first date rather than the final print date, a missing issue number, a middle name or initial dropped, or a page range off by only one or two pages. Use the authoritative source's current value and move on.
- Treat as cosmetic: title capitalization style, journal name abbreviated vs. spelled out, minor punctuation differences. These don't need to block anything.

**State a confidence level rather than presenting every citation as equally solid.** After checking, a citation should land in one of: verified against a source with matching metadata; likely correct but with a minor, noted discrepancy; needs correction because a substantive mismatch was found; or unverifiable with the tools available, in which case say so explicitly rather than presenting it as confirmed.

For a large batch of citations (a full bibliography or a long reading list), work through them in smaller groups rather than trying to hold verification state for dozens of references at once — this keeps the check itself from becoming the kind of speculative, unchecked pass it's meant to prevent.

*This verification workflow adapts ideas from the citation-checking methodology in the third-party [`nature-skills`](https://github.com/Yuan1z0825/nature-skills) project (specifically its `nature-ref-verifier` skill), rewritten here for Alt Lab's own tools and standards rather than imported directly.*
