# 02_assemble — compose the stack folder from cards

One job: produce a complete, host-ready stack folder from the answers and the matching cards.

## Inputs
- Working (this run): ../01_intake/output/<run>/answers.md
- Reference (every run): references/assembly-rules.md
- Reference (every run): ../../_shared/rules.md
- Reference (this run's agent): ../../_shared/agents/<agent>/ (card.md, compose.yml, env.example, bootstrap.md)
- Reference (this run's target): ../../_shared/targets/<target>/card.md
- Reference (chosen components only): ../../_shared/components/<name>/card.md and its files
- Reference (every run): ../../_templates/stack-README.md

Do NOT load: the other agent's folder, the other target's folder, components the answers did not choose, `ops/`.

## Process
1. Read `answers.md`. Confirm the run slug.
2. Copy the agent's `compose.yml` to `output/<run>/stack/docker-compose.yml`. Merge in component compose fragments the answers call for (Caddy when `access: domain`). Follow `references/assembly-rules.md` exactly.
3. Build `.env` from the agent's `env.example` plus component variables. Every secret stays a placeholder of the form `CHANGE_ME`. Generate non-secret random values yourself (gateway token, dashboard password) with `openssl rand -hex 24` and write them in; those are not the person's secrets.
4. Copy the target card's autostart and any component templates (Caddyfile, backup scripts) into the stack folder. Fill placeholders from the answers.
5. Write `stack/README.md` from `_templates/stack-README.md`, filled for this run.
6. Write `stack/.gitignore` containing `.env`, `data/`, `backups/`.
7. Ask for the secrets. Say which values you need and where each comes from, then offer: "Paste them here one at a time and I will put them in the file, or open the file yourself if you prefer." As each value arrives, write it into `.env` with an exact-line replace and reply only "got it". If they choose the file, open it for them (`open -t <path>` on a Mac, `code <path>` if VS Code exists) rather than telling them a path.

## Outputs
- stack/ (docker-compose.yml, .env, README.md, .gitignore, autostart files, component files) → output/<run>/

## Human check
Every `CHANGE_ME` in `stack/.env` has been replaced, by you from values the person pasted in chat, or by the person in the file. Verify with `grep -c '=CHANGE_ME' .env` returning 0. Never read the values back. Then the person reads `stack/README.md`.
