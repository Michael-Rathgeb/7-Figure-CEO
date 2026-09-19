# 04_verify — prove the agent answers and survives a restart

One job: turn "the containers are running" into "the agent works", in writing.

## Inputs
- Working (this run): ../03_deploy/output/<run>/deploy-log.md
- Working (this run): ../01_intake/output/<run>/answers.md
- Reference (every run): references/checks.md
- Reference (every run): ../../_shared/definition-of-done.md
- Reference (every run): ../../_templates/verify-report.md
- Reference (every run): ../../_templates/your-agent.md

Do NOT load: agent bootstrap files, target install files. Deployment is over; you are testing.

## Process
1. Run every check in `references/checks.md` that applies to this run's agent, target, access mode, and channels.
2. Record each as PASS or FAIL with the command and its output (secrets redacted) in `verify-report.md`.
3. On any FAIL, go back to the deploy log, fix, re-run that check. Do not mark the run done with a FAIL.
4. Write `output/<run>/your-agent.md` from `_templates/your-agent.md`: the URLs, the bot handle, the logins they will need (dashboard password, gateway token; these are the person's own values and this sheet is for them), and the five things they might ask you to do later. This is the one file the person keeps; it is the only place a secret is written in plain text on purpose, so say so at the top. If a Google Drive or similar connection exists, offer to save a copy there.
5. Hand the person the UI URL and the channel handle. Ask them to send the agent one message.

## Outputs
- verify-report.md → output/<run>/
- your-agent.md → output/<run>/ (the person's handoff sheet)

## Human check
The person sends the agent a message from their phone and pastes the reply into the report, or tells you what it said. That quote is the last line of the report. Then the run is done.
