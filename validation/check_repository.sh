#!/usr/bin/env bash

set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_root"

required_files=(
    "AGENTS.md"
    "CLAUDE.md"
    "SOUL.md"
    "IDENTITY.md"
    "USER.md"
    "manager/README.md"
    "manager/HANDOFF_CONTRACT.md"
    "agents/literature-review/IDENTITY.md"
    "agents/coding/IDENTITY.md"
    ".claude/agents/literature-review.md"
    ".claude/agents/coding.md"
    "adapters/web/chatgpt.md"
    "adapters/web/claude.md"
    "claude_scientific_overview.html"
)

for required_file in "${required_files[@]}"; do
    test -f "$required_file" || {
        echo "Missing required file: $required_file" >&2
        exit 1
    }
done

agent_name="$(awk '/^## Name$/{f=1;c=0;next} f{c++; if(c==2){print; exit}}' IDENTITY.md)"
version_number="$(awk '/^## Current Version Number$/{f=1;c=0;next} f{c++; if(c==2){gsub(/`/, ""); print; exit}}' shared/version-and-runtime.md)"
test -n "$agent_name" || { echo "Could not read Name from IDENTITY.md" >&2; exit 1; }
test -n "$version_number" || { echo "Could not read Current Version Number from shared/version-and-runtime.md" >&2; exit 1; }
version_text="${agent_name} version ${version_number}"
grep -Fq "$version_text" shared/version-and-runtime.md
grep -Fq "$version_text" shared/initial-response.md
grep -Fq "$version_text" adapters/web/chatgpt.md
grep -Fq "$version_text" adapters/web/claude.md
grep -Fq "$version_text" claude_scientific_overview.html

if rg -q 'Would you like to proceed with this selected workflow\?|wait for explicit confirmation before starting' workflows/prompt-analysis; then
    echo "Obsolete routine confirmation gate remains in Prompt Analysis." >&2
    exit 1
fi

xmllint --html --noout claude_scientific_overview.html 2>/dev/null

grep -Fq 'document.querySelectorAll("[data-copy-target]")' claude_scientific_overview.html
grep -Fq 'data-copy-target="chatgpt-prompt"' claude_scientific_overview.html
grep -Fq 'data-copy-target="claude-prompt"' claude_scientific_overview.html

github_repository='https://github.com/BCHTaimor/alt-lab-claude-scientific'
server_repository_primary='/Volumes/taimor/alt-lab-claude-scientific'
server_repository_secondary='/storage2/researchers/taimor/alt-lab-claude-scientific'

for discovery_copy in adapters/web/chatgpt.md adapters/web/claude.md claude_scientific_overview.html; do
    grep -Fq 'RDT01154' "$discovery_copy"
    grep -Fq "$github_repository" "$discovery_copy"
    grep -Fq "$server_repository_primary" "$discovery_copy"
    grep -Fq "$server_repository_secondary" "$discovery_copy"
done

echo "${agent_name} repository validation passed."
