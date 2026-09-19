# Verification checks

Run from the stack folder on the host (`~/agents/<run>/`). Prefix with `ssh <ssh_target>` when remote.

## Always
- **Services up:** `docker compose ps` — every service `running`; services with a healthcheck `healthy`.
- **Fresh image:** `docker compose images` — record image and digest in the report.
- **No secrets in compose:** `grep -iE 'api_key|token|password' docker-compose.yml` returns only `${VAR}` references, never literal values.
- **env perms:** `stat -f %Lp .env` (Mac) or `stat -c %a .env` (Linux) prints `600`.
- **Ports private:** `docker compose ps --format json | grep -o '"PublishedPort[^}]*'` or `docker port <container>` shows only `127.0.0.1:` bindings.
- **Restart policy:** `docker inspect -f '{{.HostConfig.RestartPolicy.Name}}' <container>` prints `unless-stopped`.
- **Survives restart:** on Linux `sudo systemctl restart docker`; on Mac quit and relaunch OrbStack or Docker Desktop. Wait 60 s. `docker compose ps` shows everything back.
- **Backup exists** (if chosen): `ls backups/` shows one dated archive from the deploy stage.

## Hermes
- **Gateway alive:** `docker compose logs --tail 50 hermes` shows the gateway started and the chosen platform connected, no repeated tracebacks.
- **Dashboard auth:** `curl -s -o /dev/null -w '%{http_code} %{redirect_url}' http://127.0.0.1:9119/` prints `401`, or `302` redirecting to a login page (seen 2026-09-19 with basic auth configured). A `200` on `/` without credentials is a FAIL.
- **API server** (only if enabled): `curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:8642/v1/models` prints `401` without a key.

## OpenClaw
- **Liveness and readiness, probed from inside the container:** `docker compose exec -T openclaw-gateway sh -c 'wget -qO- http://127.0.0.1:18789/healthz || node -e "fetch(\"http://127.0.0.1:18789/healthz\").then(r=>r.text()).then(console.log)"'` then the same for `/readyz` → `{"ready":true,...}`. Probe from inside because once `gateway.trustedProxies` is set, a curl from the host arrives from the trusted bridge IP without a proxy-built header set and gets `403 proxy_attribution_required`, even with a hand-added `X-Forwarded-For`.
- **Readiness over the real path:** from a device on the tailnet, `curl https://<host>.<tailnet>.ts.net:<port>/readyz` prints `{"ready":true}`. This is channel-aware; a FAIL here usually means a channel token is wrong.
- **Gateway health with token:** `docker compose exec openclaw-gateway sh -lc 'node dist/index.js gateway health --token "$OPENCLAW_GATEWAY_TOKEN"'` succeeds.
- **Control UI needs auth:** opening `http://127.0.0.1:18789/` without the token shows the pairing or unauthorized screen.
- **Through the proxy:** the Tailscale or domain URL returns `200`, not `403 proxy_attribution_required` (means `gateway.trustedProxies` is missing).
- **Model answers:** `docker compose exec -T openclaw-gateway node dist/index.js agent -m 'Reply with exactly: OK' --json` shows `result: success` with the expected provider and model.

## Access: tailscale
- `tailscale status` shows the host online.
- `tailscale serve status` shows the UI port proxied.
- From the person's phone or laptop on the tailnet: `https://<host>.<tailnet>.ts.net` loads and prompts for auth.

## Access: domain
- `curl -sI https://<domain>` returns `200` or `401` with a valid certificate, no warnings.
- `curl -sI http://<domain>` redirects to https.
- `docker compose logs caddy --tail 20` shows the certificate was obtained.

## Channel: telegram
- The person messages the bot; the agent replies within 30 s. Quote the reply.
- A second person (not on the allowlist) gets no reply or a refusal. Ask the person to test if they can.

## Channel: discord
- The bot shows online in the server. A mention gets a reply. Quote it.

## Component: composio
- Inside the container `composio whoami` prints the person's account, not an agent account.
- Ask the agent in chat what Composio apps it can reach; it should run `composio search` and answer from the output.
