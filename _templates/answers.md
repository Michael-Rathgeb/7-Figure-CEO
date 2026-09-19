---
run: <agent>-<target>
agent: hermes | openclaw
target: mac-mini | vps
has_vps: n/a | yes | no
agent_location: on-target | remote
ssh_target: none | user@host or ssh alias
vps_distro: n/a | ubuntu-24.04 | debian-12
vps_ram_gb: n/a | 4
mac_arch: n/a | arm64
docker_installed: yes | no | unknown
providers: [anthropic]
default_model: agent-default
channels: [telegram]
access: tailscale | domain | localhost
domain: none
timezone: host-default
backups: yes | no
composio: yes | no
secrets_needed: [ANTHROPIC_API_KEY, TELEGRAM_BOT_TOKEN, TELEGRAM_ALLOWED_USERS]
status: draft | approved
date: YYYY-MM-DD
---

# Answers — <run>

## In the person's words
{What they said they want the agent for. Two sentences.}

## Notes
{Port conflicts, firewall, existing services, anything unusual. "none" if none.}

## Open questions
{Anything still unknown that 02_assemble must not guess.}
