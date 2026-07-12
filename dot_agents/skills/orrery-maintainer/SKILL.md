---
name: orrery-maintainer
description: Safely update and synchronize Gabby's Orrery Obsidian knowledge base after durable infrastructure changes, architectural decisions, project-status changes, new next actions, corrections, or explicit requests to remember something. Use for lasting cross-agent knowledge, not routine code edits or transient debugging notes.
---

# Orrery Maintainer

1. Run `orrery sync --actor <agent>` before editing to incorporate remote work.
2. Read `Meta/Agent Workflow.md`, `Meta/Access Policy.md`, and the target page.
3. Prefer updating an existing page. Use the relevant file under `Templates/`
   only when a new durable subject is needed.
4. Record observed facts separately from intent. Do not infer project priority.
5. Set `updated` to today; add or refresh `observed` for live-state snapshots.
6. Use `- [ ]` Obsidian Tasks entries only for concrete next actions.
7. Never store credentials, tokens, private keys, recovery codes, or raw auth.
8. Review `git diff` inside the vault, then run
   `orrery sync --actor <codex|claude|hermes|openclaw>`.

If sync reports a conflict or active rebase, stop. Preserve both versions and
ask Gabby to resolve intent; never auto-resolve knowledge conflicts.

Update Orrery for durable state/configuration, decisions, project status or
next actions, and facts Gabby explicitly asks to remember. Skip routine code
edits, temporary test output, and session narration.
