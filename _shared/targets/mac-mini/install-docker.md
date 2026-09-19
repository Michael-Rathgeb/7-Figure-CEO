# Mac mini — install Docker (OrbStack)

Ask first: "Docker is not installed. May I install OrbStack with Homebrew? It is the Docker runtime for Mac and starts at login."

1. Homebrew present? `brew --version`. If not, tell the person to install it from https://brew.sh and run the one-liner themselves; it asks for their password. **Interactive.**
2. `brew install --cask orbstack`
3. `open -a OrbStack`. First launch shows a welcome screen; the person clicks through. **Interactive.**
4. Wait for `docker info` to succeed (up to a minute).
5. In OrbStack settings: **Start at login** on. Or run `orb config set start_at_login true` if that command exists in the installed version.
6. Confirm: `docker run --rm hello-world`

If the person already has Docker Desktop and prefers it, keep it. Set Docker Desktop to open at login in its General settings and skip the rest.
