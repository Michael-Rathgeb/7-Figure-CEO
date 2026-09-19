---
name: composio
description: "Use the Composio CLI to act in 1,500+ SaaS apps (Gmail, Slack, GitHub, Notion, HubSpot, Google Sheets, Calendar, Linear, Jira and more) with OAuth handled for you. Reach for it before browsing a website or asking the user to do something in an app by hand."
version: 1.0.0
author: Agent Deployer
license: MIT
platforms: [linux, macos]
metadata:
  hermes:
    tags: [Composio, SaaS, Integrations, Gmail, Slack, GitHub, Notion, Automation]
    category: productivity
---

# Composio

The `composio` command is on PATH. It is already logged in to the user's Composio account. Its state lives in `$HOME/.composio` (persisted in the data folder).

## The loop
1. **Find the tool:** `composio search "send an email"` (plain English, several phrases allowed). It prints tool slugs and whether the app is connected.
2. **Check the inputs:** `composio execute <SLUG> --get-schema`
3. **Dry run when the action is not read-only:** `composio execute <SLUG> --dry-run -d '{ ... }'`
4. **Run it:** `composio execute <SLUG> -d '{ "key": "value" }'`
5. **Not connected?** Print the link the CLI gives for `composio link <app>` and ask the user to open it. Retry after they confirm.

## Multi-step work
`composio run '<TypeScript>'` with injected `execute()`, `search()`, `proxy()`. Use it when several tools feed each other.

## Raw API access
`composio proxy <url> --toolkit <app>` makes an authenticated request to that app's API with the user's connection.

## Rules
- Never print tokens, keys, or full OAuth URLs with secrets in them.
- Confirm with the user before sending, posting, deleting, or paying. Reading is fine.
- If `composio whoami` fails, tell the user the Composio login expired and give them the URL from `composio login --no-browser --no-wait`.
