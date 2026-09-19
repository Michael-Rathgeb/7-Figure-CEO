---
type: agent
name: hermes
vendor: Nous Research
license: MIT
docs: https://hermes-agent.nousresearch.com/docs/user-guide/docker
docs_messaging: https://hermes-agent.nousresearch.com/docs/user-guide/messaging/telegram
image: nousresearch/hermes-agent:latest
verified: 2026-09-19
---

# Hermes Agent

Self-hosted personal agent with a gateway that connects chat platforms (Telegram, Discord, Slack, WhatsApp) to an LLM, plus a web dashboard and an optional OpenAI-compatible API server. Single container, single data folder.

## Shape
- **Image:** `nousresearch/hermes-agent:latest`, multi-arch (runs on Apple Silicon and x86 VPS).
- **Command:** `gateway run`
- **Data:** everything under `/opt/data` in the container. We mount `./data`. Holds `.env`, `config.yaml`, `SOUL.md`, `sessions/`, `memories/`, `skills/`, `logs/`, `cron/`.
- **Ports:** `9119` dashboard (only when `HERMES_DASHBOARD=1`), `8642` OpenAI-compatible API. The API server started even with `API_SERVER_ENABLED=false` on 2026-09-19; it is key-gated (`API_SERVER_KEY`, 401 otherwise) and we publish it on `127.0.0.1` only, so that is acceptable. It warns that the terminal backend is `local` (agent commands run as the container user); switch `terminal.backend` to `docker` in `config.yaml` if the person wants sandboxing.
- **Resources:** 1 GB RAM minimum, 2 to 4 GB recommended. Add `shm_size: 1g` if browser tools are enabled.

## Configuration
- Reads LLM keys and platform tokens from environment. We pass them with `env_file: .env` from the stack folder. Hermes also reads `/opt/data/.env` if it exists; we do not create that file, so there is one home for secrets.
- The dashboard fails closed: it will not start on a non-loopback bind without one auth provider. We use basic auth: `HERMES_DASHBOARD_BASIC_AUTH_USERNAME` and `_PASSWORD`. Generate the password at assembly.
- Interactive first-run wizard exists (`setup`) and writes into `/opt/data`. Not needed when env vars are set. Use it only as the fallback in `bootstrap.md`.

## Providers
| Provider (answers.md) | How Hermes gets it |
|---|---|
| `chatgpt-subscription` | OAuth device code, provider id `openai-codex`. `hermes auth add openai-codex` prints a URL and a code; the person opens the URL on any device. Credentials: `/opt/data/auth.json`. `config.yaml` then needs `model.provider: openai-codex` and `model.base_url: https://chatgpt.com/backend-api/codex`. No env var. Refresh failures quarantine the token; rerun the same command. Plan-tier eligibility is not documented upstream. |
| `anthropic` | `ANTHROPIC_API_KEY` in `.env`, or OAuth via `hermes auth add anthropic` |
| `openai` | `OPENAI_API_KEY` in `.env` |
| `openrouter` | `OPENROUTER_API_KEY` in `.env` |
| Nous Portal | `hermes setup --portal`, OAuth, billed to a Nous subscription |

## Channels
| Channel | Variables |
|---|---|
| Telegram | `TELEGRAM_BOT_TOKEN`, `TELEGRAM_ALLOWED_USERS` (numeric ids, comma-separated). Optional `TELEGRAM_HOME_CHANNEL`. |
| Discord | `DISCORD_BOT_TOKEN`. Check `docs_messaging` sibling page for the allowlist variable before assembling. |

## Known quirks
- The container starts as root (s6) and drops to uid/gid **10000** for the agent and everything in `/opt/data`. Seen 2026-09-19: `./data` came back owned by 10000, unreadable by the stack user, so `backup.sh` would fail. Always set `HERMES_UID`/`HERMES_GID` in `.env` to the stack user's ids (`id -u`, `id -g`) at assembly. If the folder was already written by 10000, `chown -R <user>:<user> data` as root once. Running the gateway itself as root needs `HERMES_ALLOW_ROOT_GATEWAY=1`; do not.
- First run writes a full `data/.env` template (about 26 KB of every known key, all empty) and a `config.yaml`. The stack `.env` passed through `env_file` is what we rely on; leave `data/.env` alone unless a key only works from there.
- `HERMES_SKIP_CONFIG_MIGRATION=1` skips schema migrations on start. Leave unset.
