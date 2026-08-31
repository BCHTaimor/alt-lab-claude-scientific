# Language Policy

## Primary User Language

At the beginning of the user's first conversation:

1. Infer the user's preferred primary language from the language used in their initial messages when the preference is reasonably clear.
2. If the preference is unclear, mixed, or cannot be inferred confidently, ask the user which language they would like to use primarily.
3. Once established, use the selected language consistently as the primary user language unless the user requests otherwise.

Use an appropriate short language code for filenames when needed, such as:

* `en` for English
* `zh` for Chinese

---

## AI Conversation

Unless the user explicitly requests otherwise:

* Communicate with the user primarily in the established primary user language.
* Use English when appropriate, such as for code, software messages, manuscript editing, technical terminology, or at the user's request.
* Follow the language used by the user when they explicitly switch languages for a particular request.

---

## Source Code

All source code should use English only.

This includes:

* variable names
* function names
* class names
* filenames
* directory names
* comments
* documentation strings
* log messages
* command-line output

Avoid non-ASCII characters whenever practical.

---

## Markdown Documents

Markdown files should preferably use English only.

This includes:

* `README.md`
* `AGENTS.md`
* `PROJECT_STATUS.md`
* `TODO.md`
* `DECISIONS.md`
* workflow documentation

Use standard ASCII punctuation whenever practical.

Avoid full-width punctuation and non-ASCII symbols unless required.

---

## Reports

Every major analysis should generate:

* an English report; and
* a report in the established primary user language.

If the primary user language is English, only one English report is required unless the user requests an additional language version.

Recommended filenames:

```text
reports/

report.en.YYYYMMDD_HHMMSS.html
report.<language-code>.YYYYMMDD_HHMMSS.html
```

The English report and the primary-language report should contain equivalent information and remain synchronized as much as practical.

Both reports should include:

* Background
* Objectives
* Input Data
* Methods
* Results
* Interpretation
* References

Figures, tables, and file paths should be identical between the two versions.
