---
type: component
name: backups
applies: backups = yes, any target
verified: 2026-09-19
---

# Backups

A dated `tar.gz` of the stack's `data/` folder and `.env`, written to `backups/` in the stack folder, keeping the last 14. Daily by cron on Linux, by a LaunchAgent on Mac. Local only in this version; the stack README tells the person to copy `backups/` somewhere else too.

## Adds to the stack
`backup.sh`, `restore.sh` at the stack root, `chmod +x`. One line in the README.

## Deploy
1. Copy both scripts into the stack. `chmod +x backup.sh restore.sh`.
2. Run once by hand: `./backup.sh`. Confirm `ls -la backups/` shows one archive.
3. Schedule daily at 03:30.
   - Linux: `( crontab -l 2>/dev/null; echo "30 3 * * * cd $HOME/agents/<run> && ./backup.sh >> backups/backup.log 2>&1" ) | crontab -`
   - Mac: a second LaunchAgent, `com.agentdeployer.<run>.backup`, same shape as the autostart one but with `StartCalendarInterval` (`Hour` 3, `Minute` 30) instead of `RunAtLoad`, running `./backup.sh`.
4. Record the schedule in the deploy log.

## Verify
`ls backups/` shows a dated archive. `tar -tzf backups/<newest>.tar.gz | head` lists `data/` and `.env`.

## Restore
`./restore.sh backups/<archive>.tar.gz` stops the stack, moves the current `data/` aside, unpacks, starts. It never deletes the old data; it renames it `data.before-restore-<timestamp>`.
