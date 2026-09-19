# VPS — survive a reboot

1. `sudo systemctl is-enabled docker` prints `enabled`. If not: `sudo systemctl enable docker`.
2. Every service in the compose has `restart: unless-stopped`. Confirm: `docker inspect -f '{{.Name}} {{.HostConfig.RestartPolicy.Name}}' $(docker compose ps -q)`.
3. That is enough. Docker starts at boot and restarts the containers. No systemd unit for the stack is needed; adding one just fights the restart policy.
4. **Test:** `sudo systemctl restart docker`, wait 30 s, `docker compose ps`. Everything back is a pass. If the person allows, `sudo reboot`, wait two minutes, reconnect, `docker compose ps`.

Optional: unattended security updates keep the box patched. `sudo apt install -y unattended-upgrades` then `sudo dpkg-reconfigure -plow unattended-upgrades`. The default config does not reboot the box on its own.
