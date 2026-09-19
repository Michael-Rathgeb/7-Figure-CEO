# VPS — hardening before the stack starts

Do these in order. Each one is a single sentence to the person before you run it. Skip a step that is already done.

1. **A normal user.** If `whoami` is `root`:
   ```
   adduser --disabled-password --gecos "" deploy
   usermod -aG sudo deploy
   mkdir -p /home/deploy/.ssh && cp ~/.ssh/authorized_keys /home/deploy/.ssh/ && chown -R deploy:deploy /home/deploy/.ssh && chmod 700 /home/deploy/.ssh
   echo 'deploy ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/deploy && chmod 440 /etc/sudoers.d/deploy
   ```
   Then confirm `ssh deploy@<host>` works **before** the next step. Ask the person to update their `ssh_target`.
2. **SSH: keys only, no root.** In `/etc/ssh/sshd_config.d/99-hardening.conf`:
   ```
   PasswordAuthentication no
   PermitRootLogin no
   PubkeyAuthentication yes
   ```
   `sudo sshd -t && sudo systemctl reload ssh`. Keep the current session open while testing a fresh login.
3. **Firewall.** Only SSH, plus 80 and 443 only when `access: domain`.
   ```
   sudo apt install -y ufw
   sudo ufw default deny incoming && sudo ufw default allow outgoing
   sudo ufw allow OpenSSH
   # only when access: domain
   sudo ufw allow 80/tcp && sudo ufw allow 443/tcp
   sudo ufw --force enable && sudo ufw status verbose
   ```
   Never allow 8642, 9119, or 18789. Those are reached through Tailscale or Caddy.
4. **Updates.** `sudo apt update && sudo apt upgrade -y`. Reboot if the kernel changed and the person agrees.
5. **Fail2ban** (cheap, optional): `sudo apt install -y fail2ban && sudo systemctl enable --now fail2ban`.
6. **Swap** if RAM is at the minimum: `sudo fallocate -l 2G /swapfile && sudo chmod 600 /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile && echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab`.

Record what was done and what was already in place in the deploy log.
