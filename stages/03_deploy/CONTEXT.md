# 03_deploy — put the stack on the host and start it

One job: get the assembled stack running on the target, once, with the person watching.

## Inputs
- Working (this run): ../02_assemble/output/<run>/stack/ (with `.env` filled)
- Working (this run): ../01_intake/output/<run>/answers.md (for `agent_location`, `ssh_target`, `target`)
- Reference (this run's target): ../../_shared/targets/<target>/ (card.md, install-docker.md, autostart.md, hardening.md on VPS)
- Reference (this run's agent): ../../_shared/agents/<agent>/bootstrap.md
- Reference (chosen components): ../../_shared/components/<name>/card.md (tailscale, caddy, backups, composio, provision-hostinger as chosen)
- Reference (every run): ../../_shared/rules.md
- Reference (every run): ../../_templates/deploy-log.md

Do NOT load: `04_verify`, `ops/`, the other agent or target.

## Process
1. Confirm `.env` has no `CHANGE_ME` left and is mode 600. Do not read it.
2. If `has_vps: no`, follow `../../_shared/components/provision-hostinger/card.md` first and write the new `ssh_target` back into `answers.md`.
3. Reach the host. `agent_location: on-target` means run commands directly. `remote` means every host command runs through `ssh <ssh_target>` and the stack is copied with `rsync -a --exclude data --exclude backups`.
4. Follow the target card in order: preflight (arch, RAM, disk, Docker), Docker install if missing (ask first), hardening on a VPS, Tailscale if chosen.
5. Copy the stack to `~/agents/<run>/` on the host. `chmod 600 .env`.
6. Follow the agent's `bootstrap.md`: pull, one-time onboarding, channel setup, `docker compose up -d`.
7. Follow the target's `autostart.md`.
8. Run `backup.sh` once if backups were chosen.
8b. If `composio: yes`, follow `../../_shared/components/composio/card.md` (host `unzip`, install into `data/`, login URL for the person, skill).
9. Write `output/<run>/deploy-log.md` as you go: each command's purpose, its outcome, every error verbatim, every card fix you made. No secrets.

## Outputs
- deploy-log.md → output/<run>/

## Human check
The person watches `docker compose logs -f` for the first minute with you and runs any step the bootstrap marks **interactive** (QR code, browser login). They say "it is up" before you move on.
