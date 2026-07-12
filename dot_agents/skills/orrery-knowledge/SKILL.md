---
name: orrery-knowledge
description: Search and interpret Gabby's Orrery Obsidian vault for durable context about her homelab, machines, services, projects, agents, decisions, runbooks, tasks, preferences, and selected personal knowledge. Use when a request depends on the current setup, prior decisions, project intent, or facts the agents should share across sessions and machines.
---

# Orrery Knowledge

Use Orrery as the canonical durable record, not as a substitute for checking
mutable live state.

1. Run `orrery doctor` if the vault location or sync state is uncertain.
2. Search narrowly with `orrery search '<terms>'`.
3. Read the smallest relevant set of pages under `$(orrery path)`.
4. Check `Meta/Access Policy.md` before using personal context.
5. Verify live machine, service, or repository state when feasible. State when a
   conclusion comes only from documentation.

Pages with `privacy: private` are available only in direct private sessions with
Gabby. Never quote, summarize, or use them in Discord, group chats, shared
sessions, or third-party messages. Never read secrets into Orrery.

If the task reveals a durable correction or decision, use the
`orrery-maintainer` workflow after completing the primary work.
