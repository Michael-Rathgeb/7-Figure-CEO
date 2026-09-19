# Mac mini — survive a reboot

The containers already have `restart: unless-stopped`; Docker brings them back when the runtime starts. The job here is making sure the runtime starts, which on a Mac means the user session comes back and the machine never sleeps.

1. **Never sleep.** `sudo pmset -a sleep 0 disksleep 0 displaysleep 10 womp 1 autorestart 1`. `autorestart 1` powers back on after a power cut. Ask before `sudo`.
2. **Automatic login.** System Settings → Users & Groups → Automatic login → the deploying user. This is a security trade-off; say so. If FileVault is on, macOS disables it; the person then has to type the password after a power cut. **Interactive.**
3. **Runtime at login.** OrbStack: Settings → Start at login. Docker Desktop: Settings → General → Start Docker Desktop when you sign in.
4. **Belt and braces: a LaunchAgent** that runs `docker compose up -d` a minute after login, so a stopped stack comes back even after a manual `docker compose stop`. Write `autostart/com.agentdeployer.<run>.plist` into the stack folder from the template below, then:
   ```
   mkdir -p ~/Library/LaunchAgents
   cp autostart/com.agentdeployer.<run>.plist ~/Library/LaunchAgents/
   launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.agentdeployer.<run>.plist
   launchctl print gui/$(id -u)/com.agentdeployer.<run> | head -5
   ```
5. **Remote access for later fixes.** System Settings → General → Sharing → Remote Login on, so the person (and a future coding agent) can SSH in. Tailscale SSH is an alternative that needs no port forwarding.

## LaunchAgent template
Replace `<run>` and `<user>`. `docker` path: `which docker`, usually `/usr/local/bin/docker` (OrbStack and Docker Desktop both link there).
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>com.agentdeployer.<run></string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/sh</string>
    <string>-c</string>
    <string>sleep 60; cd /Users/<user>/agents/<run> && /usr/local/bin/docker compose up -d</string>
  </array>
  <key>RunAtLoad</key><true/>
  <key>StandardOutPath</key><string>/Users/<user>/agents/<run>/autostart/launchd.log</string>
  <key>StandardErrorPath</key><string>/Users/<user>/agents/<run>/autostart/launchd.log</string>
</dict>
</plist>
```

## Test
Quit the runtime app fully, relaunch it, wait 60 s, `docker compose ps`. Everything back is a pass. A full reboot test is better; do it if the person agrees.
