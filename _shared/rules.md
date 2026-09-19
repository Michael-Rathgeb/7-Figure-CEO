# Rules that never bend

Read before every stage. These override anything a card or a doc page says.

## Secrets
1. Never print, echo, log, or paste a secret. Check a value exists with `grep -c '^KEY=.\+' .env`, never with `cat`.
2. Secrets live in one place: the stack's `.env`, mode 600. Never in `docker-compose.yml`, never in a card, never in an output file.
3. The person hands you secrets one of two ways, their choice: they paste each value into the chat and you write it into `.env` at once and never repeat it, or they edit the file themselves. Offer the chat way first; most people will not open a hidden file. A value pasted in chat is still a secret: never echo it, quote it, or put it in an output file.
4. Never commit a stack folder that holds a real `.env`. The stack template ships a `.gitignore` that excludes it.

## Network
5. Containers bind to `127.0.0.1` only. Nothing listens on a public interface without Tailscale or Caddy with TLS in front of it.
6. On a VPS, never open a firewall port for a web UI. Access is Tailscale or a Caddy-fronted domain, and the UI's own auth stays on.
7. SSH into a remote host only with the alias the person gave. Never disable host key checking. The person never needs to SSH or edit anything on the server themselves; if a step seems to need that, you do it and tell them what you did.

## Changes to the host
8. Ask before installing anything system-wide (Docker, Tailscale, a package). Say what and why in one line.
9. Ask before any action that deletes data: removing volumes, `docker system prune`, wiping a data folder.
10. Never run `docker compose down -v` unless the person asked to remove the agent and confirmed.

## Truthfulness
11. A stage is done when its Human check happened, not when the commands exited zero.
12. If a card disagrees with what the software actually does, the software wins. Read the `docs:` link in the card, fix the card, note the fix in the deploy log, continue.
13. Report failures with the exact error text in a code block. Never say "should work".

## Leave nothing running
14. After any interactive step you ran through a terminal (`docker compose run`, device-code logins, `ssh -tt`), check the host for leftover clients: `ps -eo pid,user,pcpu,etime,comm --sort=-pcpu | head`. Seen 2026-09-19: two `docker-compose run` clients kept spinning at 240% CPU for hours after their containers had exited, the `timeout` wrapper did not stop them, and the host tripped the provider's resource alarm. Kill the whole session tree (the `ssh`/`bash`/`timeout`/`docker` chain), then confirm `uptime` load is below the core count and `docker ps -a` shows no `*-run-*` containers.
