---
name: orrery-projects
description: Review and maintain Gabby's cross-project directory, priorities, status, repository facts, and Obsidian Tasks next actions in Orrery. Use when planning work, asking what is in flight, setting priorities, changing a project's status, capturing follow-ups, or reconciling documentation with repositories under ~/code.
---

# Orrery Projects

Start with `Projects/Index.md` and the relevant project page under
`$(orrery path)/Projects`.

- Verify repository facts with Git before changing `branch`, `observed`, or
  working-tree state.
- Preserve uncommitted work. Never clean, reset, stash, or commit a project just
  to make its page look tidy.
- Use `status: needs-review` when Gabby's intent is unknown.
- Put immediate, concrete work under `## Next Actions` using `- [ ]` Tasks
  syntax. Do not invent due dates or priorities.
- Record product purpose and durable decisions; do not turn the vault into a
  duplicate changelog for ordinary commits.

After a lasting update, follow `orrery-maintainer` and synchronize with actor
identity. In a planning-only conversation, propose the documentation change but
do not mutate the vault.
