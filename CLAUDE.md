# Agent Deployer

Deploy a self-hosted AI agent (Hermes or OpenClaw) onto a Mac mini or a VPS, with Docker Compose, secure remote access, autostart, backups, and a verified "it works" at the end. You, the coding agent reading this, do the deploying. The person answers a few questions and fills in secrets.

Built on ICM: folders carry sequencing, hierarchy carries context, files carry state. If something needs explaining, the explanation lives in that folder's CONTEXT.md.

## Where things live

| Folder | What it holds |
|---|---|
| `stages/` | the four-step deployment pipeline, in execution order |
| `_shared/agents/` | factory: one card per agent (Hermes, OpenClaw): compose, env, bootstrap |
| `_shared/targets/` | factory: one card per host type (Mac mini, VPS): Docker install, autostart |
| `_shared/components/` | factory: reusable pieces (Tailscale, Caddy, backups) |
| `_shared/rules.md` | hard rules that never bend. Read before every stage. |
| `ops/` | day-two runbooks: update, backup, restore, logs, teardown |
| `_templates/` | blank starters for every output file |

## Route by what just happened

| If | Go to | Then stop at |
|---|---|---|
| person wants to deploy an agent | `stages/01_intake/CONTEXT.md` | person approves `answers.md` |
| `answers.md` approved | `stages/02_assemble/CONTEXT.md` | person fills secrets into `.env` |
| `.env` filled | `stages/03_deploy/CONTEXT.md` | stack is running on the host |
| stack running | `stages/04_verify/CONTEXT.md` | person confirms the agent replied |
| update, backup, restore, logs, remove, re-login, add a user | `ops/CONTEXT.md` | that runbook's own check |
| person has no server yet | `_shared/components/provision-hostinger/card.md` | person confirms the price, then `ssh` works |
| packaging this workspace for someone else | `bin/package.sh` | zip holds no `output/`, no `.env` |
| asked for status | scan `stages/*/output/<run>/` | report what exists |
| something in a card is stale or wrong | the `docs:` link in that card | fix the card, then continue |

## The one rule

Nothing moves to the next stage until the person has read the output of the last one. Secrets are never printed, logged, or committed. A stage is not done until its Human check has happened.
