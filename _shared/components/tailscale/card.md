---
type: component
name: tailscale
applies: access = tailscale, any target
docs: https://tailscale.com/kb/1242/tailscale-serve
verified: partial 2026-09-19 (serve, HTTPS, MagicDNS and the URL exercised live on a host that already had Tailscale; the install and first `tailscale up` steps not yet run by the pipeline)
---

# Tailscale

**Who needs what:** the person needs a Tailscale account and the app on the device they will open the dashboard from. The server side is installed and joined by this card; the person only clicks one login link for it.

Private network between the person's devices and the host. The agent's web UI is reached at `https://<host>.<tailnet>.ts.net` from any device on their tailnet, with a real certificate, and nothing is exposed to the internet. Installed on the host, not in a container, so it also gives SSH access for later fixes.

## Adds to the stack
Nothing in compose. One line in the stack README with the UI URL.

## Deploy
1. Ask: "May I install Tailscale on the host? You will sign in once in a browser."
2. Install. Mac: `brew install --cask tailscale` then `open -a Tailscale`, or the App Store app. Linux: `curl -fsSL https://tailscale.com/install.sh | sh`.
3. Sign in. Linux: `sudo tailscale up --ssh`, prints a URL the person opens. Mac: sign in from the menu bar app. **Interactive.**
4. Enable HTTPS certificates once per tailnet: the admin console at https://login.tailscale.com/admin/dns → Enable HTTPS. Also enable MagicDNS. **Interactive.**
4b. In https://login.tailscale.com/admin/machines find the server, open its menu, **Disable key expiry**. Otherwise the node key lapses after 180 days and the dashboard URL stops working with no error on the server. **Interactive.**
5. Proxy the UI port to the tailnet with TLS. Port is `9119` for Hermes, `18789` for OpenClaw:
   ```
   sudo tailscale serve --bg 9119
   tailscale serve status
   ```
   On Mac, `tailscale` is at `/Applications/Tailscale.app/Contents/MacOS/Tailscale` if not on PATH.
6. Read the hostname: `tailscale status --self --json | grep -o '"DNSName":"[^"]*'`. Strip the trailing dot. The UI URL is `https://<that>`.
7. OpenClaw only: this URL must be in `gateway.controlUi.allowedOrigins` (bootstrap step 4).

## Verify
From the person's phone on the tailnet, the URL loads and asks for login. `tailscale serve status` lists the proxy. Nothing on `0.0.0.0`: `ss -ltnp | grep -E '9119|18789|8642'` shows only `127.0.0.1`.
