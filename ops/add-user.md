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

## A new browser or phone for the OpenClaw control UI
Every new device has to be paired once, even the owner's. After they paste the gateway token, run `docker compose exec -T openclaw-gateway node dist/index.js devices list --json`, confirm the `remoteIp` is theirs, then `devices approve <requestId>`. `devices reject <requestId>` for anything you do not recognise.
