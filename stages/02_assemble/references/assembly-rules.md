# Assembly rules

How cards combine into one stack folder. The cards hold the content; this file holds the joins.

## Folder shape on the host
```
~/agents/<run>/
├─ docker-compose.yml
├─ .env                 (mode 600, the only place secrets live)
├─ README.md            (for the person, no secrets)
├─ .gitignore
├─ data/                (agent state, created on first start)
├─ backups/             (dated tar.gz archives)
├─ backup.sh restore.sh (from components/backups)
├─ Caddyfile            (only when access: domain)
└─ autostart/           (launchd plist on Mac, notes for systemd on VPS)
```
`output/<run>/stack/` in this workspace mirrors it exactly, minus `data/` and `backups/`.

## Ports
- Every published port binds to `127.0.0.1`. Form: `"127.0.0.1:HOST:CONTAINER"`.
- If `answers.md` notes a port conflict, change the HOST side only and record it in the stack README.

## Access mode → what to add
| access | add | UI URL after deploy |
|---|---|---|
| tailscale | nothing to compose. Host-level Tailscale plus `tailscale serve` (see components/tailscale) | `https://<host>.<tailnet>.ts.net` |
| domain | `components/caddy/compose.yml` service and `Caddyfile.template` → `Caddyfile` | `https://<domain>` |
| localhost | nothing | `http://127.0.0.1:<port>` via `ssh -L` |

`domain` is VPS only. If chosen for a Mac mini, tell the person why not (home router, no static IP) and fall back to tailscale.

## Channels → env lines
Only the channels in `answers.md` get env lines. Copy the block for each from the agent's `env.example`. Remove blocks for channels not chosen so the person is not asked for tokens they do not have.

## Images
- Keep `pull_policy: always` on every agent service. `docker compose up -d` then pulls the newest image before starting, which is how updates work.
- Do not pin tags unless the person asks. Record the image digest in the deploy log after the first start.

## Resource limits
- Hermes: 4G memory, 2 CPUs. OpenClaw: 6G memory, 2 CPUs. Lower them if the host has less, and say so in the README.

## Stack user ids (Hermes)
- Set `HERMES_UID` and `HERMES_GID` in `.env` to the ids of the host user that will own `~/agents/<run>/`. Ask `03_deploy` for them if the user does not exist yet; default 1000.

## Composio (when chosen)
- Hermes: no compose change. OpenClaw: add the two bind mounts and the PATH line from `components/composio/card.md` to both services.

## Timezone
- Set `TZ` in `.env` from `answers.md`. Both agents read it.

## What never goes in the stack
- Real secrets, this workspace's paths, anything from the other agent or target card.
