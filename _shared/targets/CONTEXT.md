# _shared/targets — one folder per host type

Each target folder answers: how does Docker get here, how does the stack come back after a reboot, and how is the box kept safe. `03_deploy` follows these in order.

| File | What it is |
|---|---|
| `card.md` | identity, preflight checks, what is different about this host. Read first. |
| `install-docker.md` | install Docker if `preflight` finds none. Ask before running. |
| `autostart.md` | make the stack survive a reboot |
| `hardening.md` | VPS only: firewall, SSH, updates |

Available: `mac-mini/`, `vps/`. Adding a target (a Raspberry Pi, a NAS) = copy a folder, rewrite the files, add a row to `01_intake/references/questions.md`.
