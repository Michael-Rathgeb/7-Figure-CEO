---
type: agent
name: openclaw
vendor: OpenClaw (open source)
license: MIT
docs: https://docs.openclaw.ai/install/docker
docs_compose: https://github.com/openclaw/openclaw/blob/main/docker-compose.yml
docs_onboard: https://docs.openclaw.ai/cli/onboard
image: ghcr.io/openclaw/openclaw:latest
verified: 2026-09-19
---

# OpenClaw

Self-hosted personal AI gateway with a control UI, many chat channels (Telegram, Discord, WhatsApp, Slack, Teams, and more), agent workspaces, optional sandboxing and a browser. Two services: the long-running gateway and a CLI helper that shares its network namespace.

## Shape
- **Image:** `ghcr.io/openclaw/openclaw:latest` (Docker Hub mirror `openclaw/openclaw:latest`). Multi-arch. `latest-browser` tag adds Chromium; only if the person asks for browsing.
- **Gateway command:** `node dist/index.js gateway --bind lan --port 18789`. Bind stays `lan` inside the container so the published port works; the host side is `127.0.0.1`.
- **State:** `/home/node/.openclaw` (config `openclaw.json`, sessions, memory), `/home/node/.openclaw/workspace`, `/home/node/.config/openclaw` (auth-profile secrets). We mount `./data/state`, `./data/workspace`, `./data/auth`.
- **Ports:** `18789` gateway and control UI. `18790` bridge, `3978` MS Teams only if that channel is used. We publish `18789` on `127.0.0.1` only.
- **Resources:** 4 GB RAM (8 GB with browser), 20 GB disk. Container-side path env vars are pinned so a macOS host path in `.env` never leaks into the container (upstream issue #77436).

## Configuration
- Auth to the gateway is a token in `OPENCLAW_GATEWAY_TOKEN`. Generate it at assembly. The control UI asks for it on first open.
- Onboarding is a one-shot command that writes `openclaw.json`. Headless form exists (`--non-interactive --accept-risk`). Provider is chosen with `--auth-choice anthropic-api-key | openai-api-key | custom-api-key`; `--secret-input-mode ref` makes it reference the env var instead of copying the key into config.
- Channels are added with `channels add --channel <name> --use-env`, which reads the token from the environment and does not copy it into config. The token must stay in `.env` for the running gateway. Config changes hot-reload.
- Control UI over a non-localhost origin (Tailscale or a domain) needs that origin in `gateway.controlUi.allowedOrigins`. Set it during bootstrap.

## Health
`/healthz` liveness, `/startupz` startup, `/readyz` channel-aware readiness. All unauthenticated. `/metrics` is behind gateway auth; never expose it separately.

## Providers
| Provider (answers.md) | How OpenClaw gets it |
|---|---|
| `chatgpt-subscription` | `models auth login --provider openai --device-code`, stored as auth profile `openai:<email>` [openai/oauth] in the agent's sqlite auth store; refreshes itself. Onboard without `--auth-choice`, then `agents.defaults.model.primary: openai/<model>`. |
| `anthropic` / `openai` / `openrouter` | `--auth-choice anthropic-api-key | openai-api-key | custom-api-key` with the key in `.env` and `--secret-input-mode ref` |

## Known quirks
- Behind any proxy (Tailscale serve, Caddy) the control UI answers `403 proxy_attribution_required` until `gateway.trustedProxies` lists the proxy as the container sees it (the compose bridge gateway, e.g. `172.16.1.1`).
- The container runs as uid 1000 (`node`). On a host where the stack user is not 1000, `backup.sh` cannot read `data/`; schedule it from root's crontab or run the stack as a uid-1000 user.
- A second stack for the same person can reuse a Composio login by copying the state folder (see components/composio).
- WhatsApp login is a QR code: `channels login`, **interactive**.
- Hardening the image already drops `NET_RAW` and `NET_ADMIN` and sets `no-new-privileges`. Keep those lines.
- `OPENCLAW_ALLOW_INSECURE_PRIVATE_WS=1` allows plain-http websocket from private origins. Only needed for `access: localhost` through an SSH tunnel on a non-localhost hostname; leave empty otherwise.
