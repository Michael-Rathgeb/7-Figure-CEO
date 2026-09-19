# Re-authenticate a provider or Composio

Logins expire or get revoked. Symptoms: the agent replies with an auth error, or the log shows `invalid_grant`, `re-authenticate`, `401` from the model provider, or `composio whoami` fails. From `~/agents/<run>/` on the host. All of these are **interactive**: the person opens a URL or types a code.

## ChatGPT subscription
- Hermes: `docker compose run --rm -it hermes auth add openai-codex` → URL + code → then `docker compose restart hermes`.
- OpenClaw: `docker compose run --rm --no-deps --entrypoint node openclaw-gateway dist/index.js models auth login --provider openai --device-code` under a TTY; read the code from `docker logs <run container> | tr -d '\n\r'`. Confirm with `models auth list --provider openai`.

## API keys
Edit the key in `.env`, then `docker compose up -d --force-recreate`. Never paste the key anywhere else.

## Composio
Inside the container, as the agent's uid: `composio login --no-browser --no-wait --no-skill-install` → give the person the URL → `composio login --poll --no-skill-install` → `composio whoami`. Hermes: `docker compose exec -T -u <HERMES_UID> hermes bash -c 'export HOME=/opt/data/home; …'`. OpenClaw: `docker compose exec -T openclaw-gateway sh -c '…'`.

## Tailscale
`sudo tailscale up` on the host prints a login URL if the node key expired. Disable key expiry for the server in the Tailscale admin console to avoid this.

Check: the agent answers a message again; `composio whoami` prints the person's email.
