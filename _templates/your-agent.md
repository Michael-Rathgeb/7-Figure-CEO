# Your agent: <run>

**This sheet holds your logins. Keep it private.** It is the one place they are written out on purpose, so you never have to open a server or a config file.

## Talk to it
- Chat: <bot handle> on <Telegram | Discord>. Only your account is allowed. To add someone, tell your coding agent "let <name> message my agent".
- Dashboard: <ui_url>. Works from any device signed in to your Tailscale account.
  - Login: <user / password or token, and where to paste it>

## What it runs on
- <agent> on <host description>, deployed <date>.
- Brain: <ChatGPT subscription | provider>. Model: <model>.
- Backups: daily at <time>, kept for 14 days, on the server.

## Things to say to your coding agent later
Open the Agent Deployer folder in Claude Code or Codex and say any of these:
- "Update my agent."
- "Back up my agent." / "Restore my agent from yesterday."
- "Show me my agent's logs, something is wrong."
- "My ChatGPT login expired." / "Composio stopped working."
- "Let <name> message my agent."
- "Remove my agent."

## Where the records are
The folder this came from holds `answers.md`, `deploy-log.md`, and `verify-report.md` for this run under `stages/*/output/<run>/`. Keep the folder; it is how your coding agent knows what you have.
