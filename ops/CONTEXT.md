# ops — day-two runbooks

For a stack that already exists. Each runbook is self-contained: where to run it, the commands, what to check. Read `../_shared/rules.md` first, then only the runbook asked for.

| Person says | Runbook | Check |
|---|---|---|
| update, upgrade, get the latest | `update.md` | services healthy after, version changed |
| back up | `backup.md` | new archive listed |
| restore, roll back | `restore.md` | agent replies after restore |
| logs, what is it doing, is it broken | `logs.md` | the person understands the last error |
| stop, remove, uninstall | `teardown.md` | person confirmed before any data is deleted |
| login expired, re-authenticate, ChatGPT or Composio stopped working | `reauth.md` | agent answers again |
| let my partner / assistant message it | `add-user.md` | new person gets a reply, strangers do not |
| add Composio to an agent that is already running | `../_shared/components/composio/card.md` | `composio whoami` inside the container |

Find the stack: `ls ~/agents/` on the host, or `stages/01_intake/output/*/answers.md` in this workspace for the host and `ssh_target`.
