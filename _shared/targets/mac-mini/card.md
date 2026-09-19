---
type: target
name: mac-mini
os: macOS
arch: arm64
docs: https://docs.orbstack.dev/
verified: untested (written 2026-09-19 from docs; no Mac mini run yet)
---

# Mac mini

An Apple Silicon Mac sitting on a home or office network, behind a router, expected to run 24/7. Usually the person is at its keyboard or screen-sharing into it, so `agent_location` is often `on-target`.

## What is different here
- Docker runs inside a lightweight Linux VM. OrbStack is the recommended runtime: native arm64, low idle CPU, starts at login. Docker Desktop also works.
- Images must be arm64. Both agent images are multi-arch, so no changes to compose. If a third-party image is amd64 only, add `platform: linux/amd64` to that service and expect it to be slow.
- There is no public IP. `access: domain` does not apply. Use Tailscale.
- The Mac will sleep, log out, and pause the VM unless told not to. That is most of `autostart.md`.
- `sudo systemctl` does not exist. Restarting Docker means quitting and relaunching the runtime app.

## Preflight (run all, record in the deploy log)
```
uname -m                       # arm64
sw_vers -productVersion        # 14 or newer
sysctl -n hw.memsize | awk '{print $1/1073741824 " GB"}'
df -h ~ | tail -1              # 20 GB free or more
docker --version && docker compose version   # if this fails → install-docker.md
docker info --format '{{.OperatingSystem}}'  # OrbStack or Docker Desktop
```

## Where the stack lives
`~/agents/<run>/` in the logged-in user's home. `./data` bind mounts work with both runtimes; no named volumes needed.

## Path gotcha
The OpenClaw compose pins container-side paths for exactly this host: a `/Users/...` path leaking from `.env` into the container breaks first reply. Do not remove those `environment:` lines.
