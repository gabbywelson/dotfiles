# Global Development Guidance

- Read repository-local guidance before making changes.
- Preserve existing architecture and conventions unless the task requires otherwise.
- Keep changes scoped, test behavior that changed, and report commands that could not run.
- Never commit credentials, authentication state, generated sessions, or local environment files.
- Prefer `rg`, `fd`, structured parsers, and repository-provided scripts.
- On `dockerhost`, keep long-running work inside a named tmux session.
