# Global Development Guidance

- Read repository-local guidance before making changes.
- Preserve existing architecture and conventions unless the task requires otherwise.
- Keep changes scoped, test behavior that changed, and report commands that could not run.
- Never commit credentials, authentication state, generated sessions, or local environment files.
- Prefer `rg`, `fd`, structured parsers, and repository-provided scripts.
- On `dockerhost`, keep long-running work inside a named tmux session.

## Orrery Knowledge

- Orrery is the canonical durable record for Gabby's homelab, projects, agents, decisions, tasks, and selected personal context. Locate it with `orrery path`.
- Use the Orrery skills when work depends on machine state, prior decisions, project intent, runbooks, or durable personal context.
- Verify mutable operational facts against live state; documentation can drift.
- Update Orrery in the same task after durable configuration/infrastructure changes, architectural decisions, project-status changes, new next actions, or an explicit request to remember something. Routine code edits do not require an update.
- Never store secret values in Orrery. Respect `privacy: private`: direct sessions with Gabby only, never group or public contexts.
