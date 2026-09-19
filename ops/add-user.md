# Let another person talk to the agent

Both agents deny unknown senders by default. Adding someone means adding their Telegram numeric id (they get it from @userinfobot) or Discord user id. Ask the person who owns the agent to confirm each addition; this is access to an agent that can act on their accounts.

## Hermes
Edit `TELEGRAM_ALLOWED_USERS` in `.env`, comma-separated, then `docker compose up -d --force-recreate`.

## OpenClaw
Hot-reloads, no restart:
```
docker compose exec -T openclaw-gateway node dist/index.js config set channels.telegram.allowFrom '["<owner id>","<new id>"]'
```
To let anyone DM it (not recommended): `config set channels.telegram.dmPolicy open`.

Check: the new person sends a message and gets a reply; a stranger still gets nothing.
