---
type: component
name: composio
applies: composio = yes, any agent, any target
docs: https://docs.composio.dev/docs/cli
docs_hermes: https://composio.dev/toolkits/composio/framework/hermes-agent
docs_openclaw: https://github.com/ComposioHQ/openclaw-composio-plugin
verified: 2026-09-19
---

# Composio

Gives the agent 1,500+ SaaS tools (Gmail, Slack, GitHub, Notion, HubSpot, Sheets, Calendar, CRMs) with OAuth handled by Composio. The recommended integration for both agents is the **Composio CLI** on the agent's PATH plus a skill that teaches the agent the `search → schema → execute` loop. Composio also offers an MCP endpoint (`https://connect.composio.dev/mcp`); it is the fallback, not the default.

The CLI is one static binary (Bun-built) plus a state folder. Both must live inside the stack's persisted `data/` so they survive `docker compose pull && up -d`.

## Adds to the stack
- Hermes: binary + state under `data/home/.composio/`, entry point `data/.local/bin/composio` (a **relative** symlink), skill at `data/skills/productivity/composio/SKILL.md`. No compose change: `/opt/data/.local/bin` is already on the container PATH and tool subprocesses run with `HOME=/opt/data/home`.
- OpenClaw: two extra bind mounts in `docker-compose.yml` on both services so the binary and state persist, plus the skill installed by the CLI itself:
  ```yaml
      - ./data/composio:/home/node/.composio
      - ./data/bin:/home/node/.local/bin
  ```
  and `PATH: /home/node/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin` under `environment:` (the image does not put `~/.local/bin` on PATH).
- One line in the stack README: "Composio is installed; ask the agent to connect an app and it will hand you a link."

## Deploy
Do this **after** the agent is running (04_verify can wait), from the stack folder on the host.

1. **Prerequisite on the host: `unzip`.** The installer refuses without it, and neither agent image nor a fresh Ubuntu has it. `sudo apt-get install -y unzip` (ask first). Install on the **host**, into the data folder, not inside the container: the container is replaced on every update.
2. **Install into the persisted paths.** Hermes:
   ```
   export COMPOSIO_INSTALL_DIR=$PWD/data/home/.composio COMPOSIO_BIN_DIR=$PWD/data/.local/bin
   mkdir -p "$COMPOSIO_INSTALL_DIR" "$COMPOSIO_BIN_DIR"
   curl -fsSL https://composio.dev/install | bash -s -- --no-plugins
   ln -sfn ../../home/.composio/composio data/.local/bin/composio    # relative, so it resolves inside the container too
   ```
   OpenClaw: same, with `COMPOSIO_INSTALL_DIR=$PWD/data/composio COMPOSIO_BIN_DIR=$PWD/data/bin`, then **replace the symlink with a copy**: `rm data/bin/composio && cp data/composio/composio data/bin/composio` (96 MB). Inside the container the state is at `/home/node/.composio` and the bin at `/home/node/.local/bin`, so no relative link resolves on both sides; the CLI finds its state through `$HOME/.composio`, not through the binary's location. The installer also appends a PATH block to the host user's `~/.bashrc`; harmless.
   Ownership: everything under `data/` must belong to the uid the container runs as (`HERMES_UID`, or 1000 `node` for OpenClaw). `chown -R` if the installer ran as another user.
3. **Verify from inside the container.** Hermes: `docker compose exec -T hermes bash -c 'export HOME=/opt/data/home; which composio && composio --version'`. OpenClaw: `docker compose exec -T openclaw-gateway sh -c 'which composio && composio --version'`.
4. **Log in as the person.** **Interactive**, but only a URL. Run it **as the agent's uid**, not root: `docker compose exec -T -u <HERMES_UID> hermes bash -c 'export HOME=/opt/data/home; composio login …'` (OpenClaw's container already runs as `node`). A login run as root leaves `user_data.json` owned by root and the agent's `composio whoami` fails. Inside the container run `composio login --no-browser --no-wait --no-skill-install`. It prints a dashboard URL with a one-time `cliKey`. Show the URL to the person, then run `composio login --poll --no-skill-install` (waits up to 10 min) and `composio whoami`. Never use `composio login --agent` when a human is present; that creates a machine account instead of using theirs.
5. **Teach the agent.** Hermes: write the skill from `skill-hermes.md` in this folder to `data/skills/productivity/composio/SKILL.md`. OpenClaw: `composio --install-skill openclaw` inside the container (the CLI knows OpenClaw's skill layout), or `openclaw plugins install @composio/openclaw-plugin` for the helper commands `openclaw composio status|doctor`.
6. **Connect the first app** by asking the agent, in its chat, to "connect my Gmail with Composio". It runs `composio link gmail`, hands the person a link, and confirms with a read-only call such as `composio execute GMAIL_FETCH_EMAILS -d '{ max_results: 1 }'`.

## Verify
- `composio whoami` inside the container prints the person's account.
- The agent, asked in chat "what Composio apps can you reach?", answers with `composio search` results instead of guessing.
- After one `composio link`, a read-only execute returns real data.

## Fallback: MCP instead of CLI
Hermes `data/config.yaml`:
```yaml
mcp_servers:
  composio:
    url: "https://connect.composio.dev/mcp"
    headers:
      x-consumer-api-key: "<key from https://dashboard.composio.dev>"
    connect_timeout: 60
    timeout: 180
```
Put the key in `.env` as `COMPOSIO_API_KEY` and reference it if Hermes supports env interpolation in that block; otherwise the key sits in `config.yaml`, which is inside `data/` and already mode 600. Restart the container.

## Known quirks
- A second stack on the same host for the same person can reuse the login: copy the state folder (`cp -a`), chown to the new container's uid, verify with `whoami`. No second browser round-trip.
- The installer's symlink is absolute (`/home/<user>/.../composio`), which is wrong inside the container. Always replace it with the relative link in step 2.
- Composio's own "paste https://composio.dev/hermes into the chat" route tells the agent to add the MCP server with no auth and rely on OAuth. That is fine on a laptop with a browser; on a headless server the CLI route above is more predictable.
