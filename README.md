# Agent Deployer

Deploy your own always-on AI agent (Hermes or OpenClaw) to a VPS or a Mac mini in one sitting, with your coding agent doing the work. No SSH, no config files: you answer questions, paste two secrets into the chat, click a few login links, and message your new agent.

This is not an app. It is a folder your coding agent walks. The structure is the program. See `journey.html` for the picture, or open it at the link your host gave you.

## Get it

```
git clone https://github.com/<this repo>.git
cd "7 Figure CEO"
claude        # or: codex
```
Then say: **"Deploy an agent for me."**

## What is proven and what is not

| Path | Status |
|---|---|
| Hermes on a VPS, ChatGPT subscription, Telegram, Tailscale, Composio | Deployed and verified end to end, 2026-09-19 |
| OpenClaw on a VPS, same options | Deployed and verified end to end, 2026-09-19 |
| Buying the VPS on Hostinger through the API | Written from the API spec; the live attempt stalled on a card payment, so a completed purchase is not yet observed |
| Mac mini as the host | Written from docs, not yet run |
| Public domain with Caddy instead of Tailscale | Written from docs, not yet run |
| Anthropic / OpenAI / OpenRouter API keys instead of ChatGPT | Wired in the cards, not yet run |

Every card in `_shared/` carries a `verified:` line saying which of these it is. When your coding agent finds a card wrong, it is told to read the upstream docs, fix the card, and note it in the deploy log. Pull requests with those fixes are the point of this being public.

## How to use it

1. Open this folder in Claude Code or Codex.
2. Say: **"Deploy an agent for me."**
3. Answer the questions. When it asks for your Telegram bot token or an API key, paste it into the chat and it writes it where it belongs. Confirm each step. You never SSH into anything or edit a config file.
4. Send your new agent a message on Telegram or Discord. That is the finish line.

Everything the coding agent needs is in this folder. It reads `CLAUDE.md` first and follows the numbered stages. You review the output of each stage before the next one runs.

## What you need before you start

Have these ready and the whole thing is one sitting. Each one that is missing is a pause in the middle.

**On your laptop**
- Claude Code or Codex installed and signed in. That is the thing doing the work.
- An SSH key. Run `ssh-keygen -t ed25519` once if `~/.ssh/id_ed25519.pub` does not exist. The coding agent can do this for you.
- Your phone next to you. You will approve three or four sign-in links during the run.

**A place to run the agent**
- A VPS with 4 GB RAM or more on Ubuntu 24.04 or Debian 12, or an Apple Silicon Mac mini you can leave on.
- No server yet? A Hostinger account with a card that works. The coding agent can buy a KVM 2 for you (about $14 the first month, $25 after). If the payment does not go through, nothing appears and nothing tells you why, so check hPanel billing before waiting.

**A brain for the agent, one of**
- A ChatGPT Plus or Pro subscription (Hermes only; no API key, one device-code login).
- An Anthropic, OpenAI, or OpenRouter API key with billing set up.

**A way to talk to it**
- Telegram: make a bot with @BotFather and get your numeric id from @userinfobot. Two minutes.
- Or Discord: a bot token from the developer portal and the bot invited to your server.

**Private access to the dashboard**
- A free Tailscale account, with the Tailscale app on the phone or laptop you will open the dashboard from. Turn on HTTPS certificates and MagicDNS once in the Tailscale admin console.
- Or, for a public URL on a VPS, a domain whose DNS you control.

**Optional but recommended**
- A free Composio account, so the agent can reach Gmail, Slack, Notion, GitHub and 1,500 other apps. One login link, then one link per app you connect.

**Expect**
- 30 to 45 minutes for a first deploy, most of it the coding agent working and you approving links.
- Ongoing cost: the server, plus whatever the model provider charges.
- Keep this folder. It holds every run's answers, logs, and reports, and it is how you update, back up, or move the agent later.

## Day two

Ask your coding agent to "update the agent", "back up the agent", "show me the agent logs", or "remove the agent". The runbooks are in `ops/`.
