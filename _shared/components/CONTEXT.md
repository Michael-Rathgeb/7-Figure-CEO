# _shared/components — reusable pieces any run can pull in

A component is something that is not the agent and not the host but the run needs: private access, a public front door, backups. `02_assemble` copies files from the ones `answers.md` selects; `03_deploy` follows their `card.md`.

| Component | When it is used | Files |
|---|---|---|
| `tailscale/` | `access: tailscale` (default for both hosts) | `card.md` |
| `caddy/` | `access: domain` (VPS only) | `card.md`, `compose.yml`, `Caddyfile.template` |
| `backups/` | `backups: yes` (default) | `card.md`, `backup.sh`, `restore.sh` |
| `composio/` | `composio: yes` (default yes) | `card.md`, `skill-hermes.md`. Installed after the agent runs; one login URL for the person |
| `provision-hostinger/` | `target: vps` and the person has no server yet | `card.md` (a purchase; the person confirms price first) |

Adding one = a folder with a `card.md` that says when it applies, what it adds to the stack, how to deploy it, and how to verify it.
