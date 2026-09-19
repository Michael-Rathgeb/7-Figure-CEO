# Intake questions

Ask these in plain words. Defaults in bold. Write the answers into the frontmatter of `answers.md`.

## The agent
1. **Which agent do you want?** Hermes (Nous Research) or OpenClaw. If they are unsure: Hermes is lighter and simpler, OpenClaw has more channels and a richer control UI. → `agent: hermes | openclaw`

## The host
2. **Where will it run?** A Mac mini, or a VPS (cloud Linux box). → `target: mac-mini | vps`
3. For a VPS: **do you already have one?** If not, one can be bought for them on Hostinger in a couple of minutes (see `_shared/components/provision-hostinger/card.md`). Ask whether they have a Hostinger account, a Composio connection to it, or an API token, and which plan and location they want. Record `has_vps: no` and jump to that card before continuing here. → `has_vps: yes | no`
4. For a VPS: which distro and how much RAM? **Ubuntu 24.04** or Debian 12. Hermes wants 2 GB or more, OpenClaw 4 GB or more. → `vps_distro`, `vps_ram_gb`
5. For a Mac mini: Apple Silicon (M1 or newer)? Is Docker already installed (OrbStack or Docker Desktop)? → `mac_arch: arm64`, `docker_installed: yes | no | unknown`
6. **Am I running on the target right now, or on another machine?** If another machine: what is the SSH alias or `user@host`? → `agent_location: on-target | remote`, `ssh_target`

## Brains
7. **Which LLM provider?** A ChatGPT subscription (Hermes only, no API key, one device-code login), Anthropic, OpenAI, or OpenRouter. More than one is fine. → `providers: [chatgpt-subscription | anthropic | openai | openrouter]`
8. Which model should be the default? **Leave it to the agent's own default** unless they have a preference. → `default_model`

## How they will talk to it
9. **Telegram, Discord, or web UI only?** Telegram is the easiest to set up from a phone. → `channels: [telegram]`
10. For Telegram: they will need a bot token from @BotFather and their numeric user id from @userinfobot. Tell them now so they can fetch both while you assemble. → `secrets_needed`
11. For Discord: they will need a bot token from the Discord developer portal and the bot invited to their server. → `secrets_needed`

## Reaching the web UI
12. **How should the web UI be reached?** Tailscale (private, works for both hosts, **default**), a public domain with automatic TLS (VPS only, needs a domain pointed at the VPS), or localhost only (SSH tunnel). → `access: tailscale | domain | localhost`, `domain`

## Housekeeping
13. Timezone? Default: the host's own. → `timezone`
14. Daily backups to a folder on the host? **Yes.** → `backups: yes | no`
15. Anything unusual about the host? Another service on port 8642, 9119, or 18789? A corporate firewall? → `notes`
