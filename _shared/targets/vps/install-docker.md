# VPS — install Docker Engine

Ask first: "Docker is not installed. May I install Docker Engine from Docker's official apt repository? It runs as a system service."

Docker's convenience script handles Ubuntu and Debian on amd64 and arm64:
```
curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
sudo sh /tmp/get-docker.sh
sudo usermod -aG docker "$USER"
```
Then log out and back in (or `exec ssh <ssh_target>` again) so the group applies. Confirm:
```
docker --version && docker compose version
sudo systemctl enable --now docker
docker run --rm hello-world
```
If the person prefers the manual repo setup, follow the `docs:` link in `card.md`. Do not use the distro's `docker.io` package; its Compose is too old.
