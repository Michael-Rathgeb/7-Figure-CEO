# Agent Deployer — the pipeline

The flow in one line: ask, assemble, deploy, prove it.

One run = one agent on one host. Its slug is `<agent>-<target>`, for example `hermes-mac-mini`. Every stage writes into `output/<run>/` so several runs can live side by side.

| Stage | Job | Input | Output | Human check |
|---|---|---|---|---|
| `01_intake` | collect the few facts that shape the stack | the person, `references/questions.md` | `output/<run>/answers.md` | reads answers, corrects anything wrong |
| `02_assemble` | compose the stack folder from cards | 01's answers, agent card, target card, component cards | `output/<run>/stack/` | fills in `.env`, reads `README.md` |
| `03_deploy` | put the stack on the host and start it | 02's stack | `output/<run>/deploy-log.md` | watches the first start, runs any interactive step |
| `04_verify` | prove the agent answers and survives a reboot | running stack, `references/checks.md` | `output/<run>/verify-report.md`, `output/<run>/your-agent.md` | sends the agent a message, gets a reply, keeps the handoff sheet |

Factory (stable, every run): `_shared/agents/`, `_shared/targets/`, `_shared/components/`, `_shared/rules.md`
Product (new each run): each stage's `output/<run>/`

Status is whatever exists: a stage is COMPLETE for a run when its `output/<run>/` holds the artifact named above. A `.gitkeep` does not count.
