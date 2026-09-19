# Remove the agent

Two levels. Confirm which one the person wants, in their words, before running anything.

## Stop it, keep everything
```
docker compose down
launchctl bootout gui/$(id -u)/com.agentdeployer.<run>   # Mac only, if the LaunchAgent exists
```
Data, `.env`, and backups stay. `docker compose up -d` brings it back.

## Delete it
Ask: "This deletes the agent's memory, sessions, and keys on this host. Backups in `backups/` go too unless I keep them. Delete everything, or keep the backups folder?"
```
./backup.sh                                # one last archive, offer to copy it off-host
docker compose down --rmi all
launchctl bootout gui/$(id -u)/com.agentdeployer.<run> 2>/dev/null; rm -f ~/Library/LaunchAgents/com.agentdeployer.<run>*.plist   # Mac
crontab -l | grep -v "agents/<run>" | crontab -                                                                                  # Linux
sudo tailscale serve reset                 # if this was the only served port
rm -rf ~/agents/<run>                      # only after the person said "delete everything"
```
Check: `docker ps -a` shows no containers from this run, `ls ~/agents/` no longer lists it. Tell the person what was kept.
