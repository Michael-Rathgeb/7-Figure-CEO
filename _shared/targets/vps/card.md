---
type: target
name: vps
os: Ubuntu 24.04 / Debian 12
arch: amd64 or arm64
docs: https://docs.docker.com/engine/install/ubuntu/
verified: 2026-09-19
---

# VPS

A cloud Linux box with a public IP (Hetzner, DigitalOcean, Vultr, Linode, Lightsail, and the like). The person is almost never at its keyboard, so `agent_location` is usually `remote` and every command runs through `ssh <ssh_target>`.

## What is different here
- It is on the public internet. Everything in `hardening.md` happens before the stack starts, and every port stays on `127.0.0.1`.
- Docker Engine installs from Docker's apt repo, runs as a systemd service enabled at boot. `restart: unless-stopped` is the whole autostart story.
- `access: domain` is possible: point an A record at the VPS, Caddy gets a certificate. `access: tailscale` also works and needs no domain.
- Root logins are common on fresh VPSes. Create a normal user with sudo first; the stack lives in that user's home.
- Docker publishes ports by rewriting iptables and bypasses ufw. Binding to `127.0.0.1` sidesteps that. Never publish on `0.0.0.0` here.

## Preflight (run all through ssh, record in the deploy log)
```
uname -m; . /etc/os-release && echo "$PRETTY_NAME"
free -g | awk '/Mem/ {print $2 " GB"}'          # Hermes ≥ 2, OpenClaw ≥ 4
df -h / | tail -1                                # 20 GB free or more
whoami                                           # not root → good. root → hardening.md step 1
docker --version && docker compose version       # if this fails → install-docker.md
systemctl is-enabled docker                      # enabled
```

## Where the stack lives
`~/agents/<run>/` in the sudo user's home. Copy with `rsync -a --exclude data --exclude backups stack/ <ssh_target>:~/agents/<run>/`.
