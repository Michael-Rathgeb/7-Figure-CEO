# Hermes — first start

Run from `~/agents/<run>/` on the host. No step here is interactive unless marked.

1. **Pull.** `docker compose pull`
2. **Prepare data folder.** `mkdir -p data && chmod 700 data`
2b. **Provider login, only when `providers` includes `chatgpt-subscription`.** **Interactive**, but works over SSH: the command prints a URL and a short code, the person opens the URL on their phone or laptop, signs in to ChatGPT, enters the code.
   ```
   docker compose run --rm -it hermes auth add openai-codex
   ```
   Then make it the default model provider. If `data/config.yaml` does not exist yet or `model.provider` is not `openai-codex`, either run `docker compose run --rm -it hermes model` and pick "ChatGPT or Codex Subscription", or set these two keys in `data/config.yaml` (a working deployment on 2026-09-19 used exactly these):
   ```yaml
   model:
     provider: openai-codex
     base_url: https://chatgpt.com/backend-api/codex
   ```
   Confirm `data/auth.json` exists and is mode 600. Never print it. `auth add` writes only the auth store; it does **not** touch `config.yaml` (verified 2026-09-19), so the model block above is always needed.
2c. **Config version marker.** The first run copies the image's example `config.yaml`, which carries no `_config_version`, and the gateway then warns that the config "predates version 12" and cannot be auto-migrated. Fix it with Hermes' own tool once the container is up: `docker compose exec -T hermes hermes config migrate`, then `docker compose restart hermes` and confirm the `config-migrate` warning is gone from the logs. (`hermes config check` shows the state first.)
3. **Start.** `docker compose up -d`
4. **Watch the first minute.** `docker compose logs -f hermes` with the person. You want to see: the gateway starting, the dashboard listening on 9119, the platform (Telegram or Discord) connecting. Stop watching with Ctrl-C; the container keeps running.
5. **If the log asks for setup or says no provider is configured:** run the wizard once with the person at the keyboard. **Interactive.**
   ```
   docker compose run --rm -it hermes setup
   ```
   It writes into `./data`. Then `docker compose up -d` again. Note in the deploy log that the wizard was needed and what it asked for, so the card can be fixed.
6. **If `./data` shows permission errors:** add to `.env` the host user's ids (`id -u`, `id -g`) as `HERMES_UID=` and `HERMES_GID=`, then pass them through `environment:` in the compose and recreate: `docker compose up -d --force-recreate`.
7. **Dashboard check.** `curl -s -o /dev/null -w '%{http_code} %{redirect_url}\n' http://127.0.0.1:9119/` prints `302` to `/login` (or `401`). The login is the basic-auth user and password from `.env`.
7b. **Model check without a chat channel.** The OpenAI-compatible API on 8642 runs even with `API_SERVER_ENABLED=false` and is gated by `API_SERVER_KEY`. From the stack folder: `K=$(grep '^HERMES_API_KEY=' .env | cut -d= -f2); curl -s -H "Authorization: Bearer $K" -H 'content-type: application/json' http://127.0.0.1:8642/v1/chat/completions -d '{"model":"<default model>","messages":[{"role":"user","content":"Reply with exactly: OK"}]}'`. A reply proves the provider works before anyone touches Telegram.
8. **Record** the image digest: `docker compose images`.

The gateway hot-reloads nothing. Any `.env` change needs `docker compose up -d --force-recreate`.
