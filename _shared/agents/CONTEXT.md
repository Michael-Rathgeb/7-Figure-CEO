# _shared/agents — one folder per deployable agent

Each agent folder has the same four files. `02_assemble` copies from them; `03_deploy` follows `bootstrap.md`.

| File | What it is |
|---|---|
| `card.md` | identity, image, ports, volumes, docs links, known quirks. Read first. |
| `compose.yml` | the complete compose file for this agent alone, ports on 127.0.0.1, secrets as `${VAR}` |
| `env.example` | every variable the compose and the agent read, grouped, with `CHANGE_ME` for secrets and a one-line "where to get it" |
| `bootstrap.md` | the one-time first-start sequence: pull, onboard, channels, up, what to watch in the logs |

Available: `hermes/`, `openclaw/`. Adding an agent = copy a folder, rewrite the four files, add a row to `01_intake/references/questions.md`.

Cards go stale. Every card carries a `docs:` line and a `verified:` date. When the software disagrees with the card, the software wins: fix the card, bump the date.
