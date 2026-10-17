# HPCC4 Team 21 Blue Team toolkit

## Verified addressing from supplied competition format (confirm against packet)
- guidance: `172.16.21.10` — Ubuntu 22.04; SSH and PlinkCom HTTP
- ignition: `172.16.21.20` — Fedora Server 38; SSH and OpenWebUI HTTP
- assembly: `172.16.21.30` — Windows Server 2022; RDP and Jenkins (8080)
- manifest: `172.16.21.40` — Windows Server 2019; RDP and MariaDB
- blackbox: `172.16.21.5` — Linux Mint 22, out-of-scope SIEM/backups

**Important:** IPs use the guide's `t=21` convention; actual ports and scorer source addresses need live verification. No supplied source identifies a fixed scoring engine IP.

## Linux quick start
On guidance or ignition, from `Linux/`:
```bash
chmod +x *.sh
sudo ./baseline.sh
sudo ./persistence-audit.sh
sudo ./backup.sh
# After verifying blackbox SSH host key and backup account:
sudo BLACKBOX_USER=jmoney ./backup.sh --to-blackbox
sudo ./passwords.sh plinktern
sudo ./passwords.sh jmoney  # update NEIGH immediately
sudo ./service-watchdog.sh --check
sudo ./egress-audit.sh
```
Use `firewall-ubuntu.sh --preview` on guidance and `firewall-fedora.sh --preview` on ignition. `--apply` requires confirmation. Firewall rules are NOT guaranteed safe without confirming scoring IP reachability and actual service ports. `ssh-harden.sh` is a manual-review helper, not blind access control.

## Windows quick start
In elevated PowerShell on assembly/manifest:
```powershell
.\Baseline.ps1
.\Persistence-Audit.ps1
.\Backup.ps1
.\Rotate-Password.ps1 -User plinktern
.\Rotate-Password.ps1 -User jmoney  # update NEIGH immediately
.\Firewall-Preview.ps1
.\Service-Watchdog.ps1
.\Egress-Audit.ps1
```
Depending on script execution policy, signed scripts or an approved administrative execution method may be needed. Do not weaken machine policy casually.

## Deliberate safety decisions
- Audits are read-only; no account or file deletion.
- No automatic killing of `nc`, `socat`, system processes, or mass-clearing `/tmp` (these can be legitimate or destroy evidence).
- No default-deny egress automation until DNS, package updates, blackbox connectivity, scoring, and application dependencies are documented. `egress-audit.sh` and `Egress-Audit.ps1` create inputs for that controlled policy.
- Watchdogs check, but do not auto-restart, because the service manager, dependencies, and actual health endpoints can vary. Add reviewed restart rules only after practice-box validation.
- Password rotation uses secure interactive prompts, does not print passwords or log plaintext, and requires NEIGH update for jmoney. App accounts often require app-specific API/config actions and should not be rotated by Linux `passwd`.
- Linux backups include potentially sensitive configuration and user lists, and must be protected. Shadow hashes and live DB dumps are excluded; do app-specific authenticated exports separately. `mysqldump` from Linux is not applicable to the guide's Windows-hosted MariaDB unless there is a supported access path.
- Windows backups are inventories, not consistent Jenkins or MariaDB backups.
- Verify all scripts on practice VMs, and maintain console access before making any live change.

## Installers and account review (Team 21 update)
The installers only copy scripts and do not harden, alter accounts, or install system packages.
- Linux: from `Linux/`, run `bash install.sh` (default destination `~/hpcc21-linux`), then `sudo ./user-hardening.sh` to audit. To lock a *reviewed* nonessential user, `sudo ./user-hardening.sh --lock username` (interactive confirmation). Password locking alone does not block SSH keys.
- Windows: from `Windows/`, run `./Install.ps1` (default destination `~/HPCC21-Windows`), then `./User-Hardening.ps1` for audit. To disable an approved unexpected user, `./User-Hardening.ps1 -DisableUser username` (interactive confirmation). Run with appropriate administrative permissions.
- Never disable `jmoney` or `plinktern`; check official scoring and service accounts first. Windows built-in Guest is reserved for manual review.
- Verify scripts on a practice host. Do not pipe remote installers to a shell.
