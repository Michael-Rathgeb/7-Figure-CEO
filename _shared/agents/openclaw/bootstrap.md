# OpenClaw — first start

Run from `~/agents/<run>/` on the host. Onboarding runs through the gateway service with `--no-deps --entrypoint node` because the CLI service shares the gateway's network and cannot start before it.

1. **Pull.** `docker compose pull`
2. **Prepare data folders.** `mkdir -p data/state data/workspace data/auth && chmod 700 data data/*`
3. **Onboard, headless.** For an API-key provider pick `--auth-choice` from `answers.md`: `anthropic-api-key`, `openai-api-key`, or `custom-api-key` for OpenRouter. For `chatgpt-subscription` **omit `--auth-choice` entirely** (verified 2026-09-19: onboarding completes without a provider) and do step 3b afterwards. Add `--skip-skills --skip-ui --skip-hooks --skip-search --suppress-gateway-token-output` so nothing prompts and the token never prints.
   ```
   docker compose run -T --rm --no-deps --entrypoint node openclaw-gateway \
     dist/index.js onboard --non-interactive --accept-risk --skip-health \
     --mode local \
     --auth-choice anthropic-api-key \
     --secret-input-mode ref \
     --gateway-auth token \
     --gateway-token-ref-env OPENCLAW_GATEWAY_TOKEN \
     --skip-channels \
     --no-install-daemon
   ```
   If it complains about ownership of `./data/state`, run `sudo chown -R 1000:1000 data` (the image's `node` user) and retry.
3b. **ChatGPT subscription login (only for `chatgpt-subscription`).** **Interactive**, device code, needs a TTY:
   ```
   docker compose run --rm --no-deps --entrypoint node openclaw-gateway dist/index.js models auth login --provider openai --device-code
   ```
   Run it under `ssh -tt` in the background. The output is a spinner that rewrites the line, so read it with `docker logs <run container> | tr -d '\n\r'` and look for `URL: https://auth.openai.com/codex/device` and `Code: XXXX-XXXXX`. Show both to the person. Confirm with `models auth list --provider openai` (`openai:<email> [openai/oauth; expires …]`). Then set the model: `config set agents.defaults.model.primary openai/<model>` (a working deployment used `openai/gpt-5.6-sol`).
3c. **Run one-off `config set` calls with `timeout 120`** and clean up with `docker ps -aq --filter name=<run>-openclaw-gateway-run | xargs -r docker rm -f`. Seen 2026-09-19: the run container printed `Updated 4 config paths` and then hung after `Codex agent harness dispose hook failed`. Once the gateway is up, prefer `docker compose exec -T openclaw-gateway node dist/index.js config set …`, which hot-reloads.
4. **Allow the UI origin and trust the proxy.** Replace `<origin>` with the URL the person will use: `https://<host>.<tailnet>.ts.net[:port]` or `https://<domain>`. Keep the two localhost entries. **Also** add `{"path":"gateway.trustedProxies","value":["<bridge-gateway-ip>"]}` where the IP is `docker network inspect <run>_default --format '{{(index .IPAM.Config 0).Gateway}}'`. Without it every request through Tailscale serve or Caddy gets `403 proxy_attribution_required` (seen 2026-09-19).
   ```
   docker compose run -T --rm --no-deps --entrypoint node openclaw-gateway \
     dist/index.js config set --batch-json \
     '[{"path":"gateway.mode","value":"local"},{"path":"gateway.bind","value":"lan"},{"path":"gateway.controlUi.allowedOrigins","value":["http://localhost:18789","http://127.0.0.1:18789","<origin>"]}]'
   ```
5. **Add channels**, one command per channel in `answers.md`. The token is read from `.env`, not copied into config. Then lock DMs to the person: `config set --batch-json '[{"path":"channels.telegram.dmPolicy","value":"allowlist"},{"path":"channels.telegram.allowFrom","value":["<numeric id>"]}]'` (default is `pairing`, which makes them approve themselves with `openclaw pairing approve`). A placeholder token makes the channel exit with `getMe returned 404`; it reconnects on the next hot reload once the real token is in `.env`.
   ```
   docker compose run -T --rm --no-deps --entrypoint node openclaw-gateway dist/index.js channels add --channel telegram --use-env
   docker compose run -T --rm --no-deps --entrypoint node openclaw-gateway dist/index.js channels add --channel discord --use-env
   ```
   WhatsApp is a QR login and needs the gateway running first: after step 6, `docker compose run --rm openclaw-cli channels login`. **Interactive.**
6. **Start.** `docker compose up -d openclaw-gateway`
7. **Watch the first minute.** `docker compose logs -f openclaw-gateway` with the person. You want: migrations done, channels connected, healthcheck turning `healthy` in `docker compose ps`.
8. **Health.** `curl -fsS http://127.0.0.1:18789/healthz && curl -fsS http://127.0.0.1:18789/readyz`. `readyz` is `false` until every configured channel is connected. After step 4 sets `gateway.trustedProxies`, curls from the host get `403 proxy_attribution_required` (a hand-added `X-Forwarded-For` does not help). Probe from inside the container instead: `docker compose exec -T openclaw-gateway sh -c 'wget -qO- http://127.0.0.1:18789/readyz || node -e "fetch(\"http://127.0.0.1:18789/readyz\").then(r=>r.text()).then(console.log)"'`, or through the Tailscale/Caddy URL.
8b. **Model check without a chat channel.** `docker compose exec -T openclaw-gateway node dist/index.js agent -m 'Reply with exactly: OK' --json`; the `executionTrace` shows provider, model and `result: success`.
9. **Hand over the token.** Tell the person: open the UI URL, open Settings, paste the value of `OPENCLAW_GATEWAY_TOKEN` from `.env`. They read it from the file themselves; you do not print it.
10. **Record** the image digest: `docker compose images`.

Day-two CLI use: `docker compose run --rm openclaw-cli <command>` (the `cli` profile keeps it out of `up -d`). Doctor: `docker compose run --rm openclaw-cli doctor --fix`.
