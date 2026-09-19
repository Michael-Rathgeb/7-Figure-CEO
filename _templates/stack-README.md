# <run> — your agent

Deployed on <date> to <host>. Agent: <agent>. Reached at: <ui_url>. Talk to it on: <channel handle>.

## Everyday
| Do | Command (from this folder) |
|---|---|
| see status | `docker compose ps` |
| see logs | `docker compose logs -f --tail 100` |
| update | `./backup.sh && docker compose pull && docker compose up -d` |
| back up | `./backup.sh` (also runs daily at 03:30, keeps 14) |
| restore | `./restore.sh backups/<archive>.tar.gz` |
| stop | `docker compose down` |
| start | `docker compose up -d` |

## Where things are
- `.env` holds your API keys and tokens. Keep it private. Mode 600. Not in git.
- `data/` is the agent's memory. Back it up. `backups/` holds the daily archives. Copy them off this machine now and then.
- `docker-compose.yml` is the stack. Ports are on 127.0.0.1 only; the world reaches the UI through <access mode>.

## If something breaks
You do not need to log into this server. Open the Agent Deployer folder on your laptop in Claude Code or Codex and say what you see; it will look for you. The runbooks are in the workspace's `ops/` folder.

## Notes from deployment
<anything unusual: changed ports, lowered memory limits, skipped steps>
