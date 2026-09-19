---
type: component
name: provision-hostinger
applies: target = vps and the person has no VPS yet
docs: https://docs.hostinger.com/api-reference/endpoints/vps
spec: https://developers.hostinger.com/openapi/openapi.json
verified: partial 2026-09-19 (list/catalog/data-center calls and the 202 stalled-payment path seen live; a completed purchase not yet observed)
---

# Provision a Hostinger VPS

For the person who says "I don't have a server." One API call buys a KVM plan, installs Ubuntu, sets the root password, and drops in their SSH public key. Result: an `ssh_target` for `answers.md` within about two minutes. This is a **purchase**; the person confirms plan and price in their own words before the call runs.

## Adds to the stack
Nothing. It produces the host. Record the VM id, IP, hostname, and plan in `answers.md` under Notes.

## Ways to call the API
| The person has | Use |
|---|---|
| Composio with a Hostinger connection | `composio proxy <url> --toolkit hostinger --account <alias> -X POST -d '<json>'` |
| A Hostinger API token (hPanel → Account → API) | `curl -H "Authorization: Bearer $HOSTINGER_API_TOKEN" -H 'content-type: application/json' <url> -d '<json>'` |
| Neither | Buy a KVM 1 or KVM 2 in hPanel by hand, choose Ubuntu 24.04, paste their SSH key. Then continue with `answers.md`. |

Base URL: `https://developers.hostinger.com`.

## Deploy
1. **SSH key.** `ls ~/.ssh/id_ed25519.pub || ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""`. Read the `.pub` file; it is public and safe to send.
2. **Pick the plan.** `GET /api/vps/v1/catalog?category=VPS` (or the `HOSTINGER_LIST_CATALOG_ITEMS` tool). Prices are in cents. Hermes fits KVM 1 (4 GB); OpenClaw wants KVM 2 (8 GB). The `item_id` includes the billing period: `hostingercom-vps-kvm2-usd-1m` is monthly.
3. **Pick the location.** `GET /api/vps/v1/data-centers`. Nearest to the person.
4. **Pick the OS.** `GET /api/vps/v1/templates`. Use plain `Ubuntu 24.04 LTS` (id 1077 on 2026-09-19; re-check) so the target card's Docker install runs unchanged. The "with Docker" template also works but ages independently.
5. **Confirm with the person.** Say the plan, the first-period price, the renewal price, and the location. Wait for "yes".
6. **Purchase and set up in one call.** Password: generate with `openssl rand -base64 18`, hand it to the person once, never log it. They will not need it; SSH key login is what we use.
   ```
   POST /api/vps/v1/virtual-machines
   {
     "item_id": "hostingercom-vps-kvm2-usd-1m",
     "setup": {
       "template_id": 1077,
       "data_center_id": 9,
       "hostname": "<run>.example",
       "password": "<generated>",
       "enable_backups": true,
       "public_key": { "name": "agent-deployer", "key": "<contents of id_ed25519.pub>" }
     }
   }
   ```
   `payment_method_id` is optional; the account default is used. A `200` returns the order and the `virtual_machine` with its `id` and `ipv4`. A `202` (body `status: payment_initiated`) means the card charge is pending and **nothing was provisioned**. Seen live on 2026-09-19: the response looked fine, but no subscription and no VM appeared for over ten minutes, and there is no API endpoint to read a billing order's status (`GET /api/billing/v1/orders` is not supported). What to do:
   - Ask the person to open [hPanel → Billing](https://hpanel.hostinger.com/billing/payment-history). A pending payment usually needs a 3-D Secure confirmation from their bank, or the card was declined.
   - Poll `GET /api/billing/v1/subscriptions` for a new VPS subscription and `GET /api/vps/v1/virtual-machines` for a new VM. When the VM shows `state: initial`, call `POST /api/vps/v1/virtual-machines/{id}/setup` with the same `setup` body (generate a fresh password).
   - If nothing appears after the person confirms the payment, buy the plan in hPanel by hand and continue from step 7. Do not re-run the purchase call blindly; a second `202` can mean a second pending charge.
7. **Wait for `running`.** Poll `GET /api/vps/v1/virtual-machines/{id}` every 20 s until `state` is `running`. Usually one to three minutes.
8. **Add an SSH alias** to `~/.ssh/config` so every later command is short:
   ```
   Host <run>
     HostName <ipv4>
     User root
     IdentityFile ~/.ssh/id_ed25519
   ```
9. **First login.** `ssh -o StrictHostKeyChecking=accept-new <run> 'uname -a'`. Then hand off to `targets/vps/hardening.md`, which creates the non-root user and turns off password login.

## Verify
`ssh <run> true` exits 0 with no password prompt. `answers.md` has `ssh_target: <run>` and the VM id under Notes.

## Existing keys
If the account already has the person's key (`GET /api/vps/v1/public-keys`), attach it to a VM that was bought without one: `POST /api/vps/v1/public-keys/attach/{virtualMachineId}` with `{"ids":[<keyId>]}`.

## Root password
Hostinger never returns a root password. It is set at purchase or with `POST /api/vps/v1/virtual-machines/{id}/recreate` (which wipes the disk). With the SSH key in place, nobody needs it.
