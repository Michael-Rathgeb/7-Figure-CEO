# Definition of done

A run is done when all of these are true and written in `stages/04_verify/output/<run>/verify-report.md`:

- `docker compose ps` shows every service `running` and, where a healthcheck exists, `healthy`.
- The web UI answers on its private URL (Tailscale or Caddy) and asks for auth.
- The person sent the agent a message on the chosen channel and got a reply, quoted in the report.
- Docker was restarted (or the host rebooted) and the stack came back on its own.
- A backup ran once and produced a dated archive in the stack's `backups/` folder.
- `README.md` inside the stack folder tells the person how to update, back up, view logs, and stop it without you.
- `your-agent.md` exists: the person has, in one place, every link and login they need and the sentences to say to you for day-two work. They never had to SSH or open a config file to get here.
