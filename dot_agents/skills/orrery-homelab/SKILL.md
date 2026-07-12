---
name: orrery-homelab
description: Operate and document Gabby's Orrery homelab across the MacBook Pro and Debian dockerhost. Use for SSH, tmux, Docker Compose, Tailscale, systemd, monitoring, backups, resident agents, dotfiles, machine setup, service changes, incident recovery, or questions about how the environment is organized.
---

# Orrery Homelab

1. Read `Homelab/Orrery Overview.md`, the relevant machine/service page, and an
   applicable `Runbooks/` page.
2. Inspect live state before acting. Documentation can drift.
3. Preserve existing configs and take a dated backup before risky changes.
4. Ask before destructive actions, public exposure, credential changes, or
   changes that can interrupt resident agents.
5. Validate the full workflow after changes, including service health and the
   client path that Gabby uses.
6. Update inventory/runbooks/decisions in the same task when the change is
   durable, then use `orrery sync --actor <agent>`.

Current conventions: `ssh dockerhost`, named tmux sessions for long-running
work, Docker from the Mac through context `dockerhost`, and chezmoi-managed
dotfiles on both machines. Never store secret values in the vault.
