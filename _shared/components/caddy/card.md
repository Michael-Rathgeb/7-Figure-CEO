---
type: component
name: caddy
applies: access = domain, target = vps
docs: https://caddyserver.com/docs/caddyfile
verified: untested (written 2026-09-19 from docs; both live runs used Tailscale)
---

# Caddy

Public HTTPS front door with automatic certificates. Only for a VPS with a domain the person controls. The agent's own auth (Hermes basic auth, OpenClaw gateway token) stays on; Caddy just terminates TLS and forwards.

## Adds to the stack
- The `caddy` service from `compose.yml` merged into `docker-compose.yml` (same `services:` map).
- `Caddyfile` from `Caddyfile.template` with `<domain>` and the upstream port filled in: `hermes:9119` or `openclaw-gateway:18789`.
- Firewall ports 80 and 443 (hardening step 3).

## Deploy
1. DNS first: an A record (and AAAA if the VPS has IPv6) for `<domain>` pointing at the VPS IP. Check: `dig +short <domain>` prints the IP. Certificates fail until this resolves. **Interactive** if the person has to log into their registrar.
2. `docker compose up -d caddy`
3. `docker compose logs caddy --tail 30` shows `certificate obtained successfully`.
4. OpenClaw only: `https://<domain>` must be in `gateway.controlUi.allowedOrigins` (bootstrap step 4).

## Verify
`curl -sI https://<domain>` returns `200` or `401`. `curl -sI http://<domain>` returns a `308` redirect to https. Browser shows a valid padlock.
