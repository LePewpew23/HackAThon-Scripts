# HPCC4 Blue Team Linux Toolkit (starter)

**Use only on authorized competition machines.** This toolkit was written from the described Horse Plinko environment, not tested against the competition images. Review actual rules, port list and scoring first. No script guarantees scoring compatibility.

## Machines
- `guidance` Ubuntu 22.04: SSH + HTTP PlinkCom
- `ignition` Fedora 38: SSH + HTTP OpenWebUI (could be container/reverse-proxy)
- `blackbox` Linux Mint: SIEM and backup target
- Windows nodes need separate PowerShell tooling.

## First run
```bash
chmod +x *.sh
sudo ./baseline.sh
sudo ./persistence-audit.sh
sudo ./backup.sh
./service-check.sh http://127.0.0.1/ # only if HTTP root should answer 200
```
Reports live under `/root/hpcc-reports`; backups under `/root/hpcc-backups`. These directories contain security-sensitive data. Baseline reports are not evidence of a clean environment; collect before and after hardening and inspect differences.

## Backup transfer (after making remote folder)
```bash
# on blackbox: mkdir -m 700 -p ~/hpcc-backups
sudo BLACKBOX_HOST=172.16.T.5 BLACKBOX_USER=jmoney ./backup.sh --to-blackbox
```
Replace T with team number. `scp` uses an interactive authentication method; verify stored archives on blackbox with `sha256sum -c`. Never blindly restore an entire `/etc` archive; extract only the required file with the correct ownership, permissions, and service-specific validation. Test restoration safely. Database, OpenWebUI volumes, and other application-specific state require independent backups.

## Credential rotation
```bash
sudo ./passwords.sh plinktern
sudo ./passwords.sh jmoney
```
Change password only after coordinating with teammates. **Immediately update `jmoney` in NEIGH** and verify scored login. Script uses interactive `passwd` and never logs passwords.

## SSH
`ssh-harden.sh` backs up and audits sshd settings. It intentionally **does not** edit config or restart SSH. Run `sshd -t`, verify second login session, then reload only after review.

## Firewall
Run `--preview` first. Ubuntu: `firewall-ubuntu.sh --apply` adds 22/tcp + 80/tcp and default-deny incoming to UFW (existing rules preserved). Fedora: `firewall-fedora.sh --apply` adds SSH+HTTP rules to the runtime default zone only. **Both need verification of scoring sources, actual service ports, active zone, Docker interfaces, app dependencies and console recovery before apply.** Firewall changes can lock out even if simple. No unconditional port reset, reboot, or egress blocking.

## HTTP service check
```bash
./service-check.sh http://127.0.0.1/ 'expected visible text'
```
Adjust URL and expected content to match **actual** scored application. Authenticated apps may return redirects/login pages or non-200 codes: do not mistake this for complete scoring verification. Also check NEIGH and remote connectivity.

## Diff reports
```bash
./changes-diff.sh /root/hpcc-reports/old.txt /root/hpcc-reports/new.txt
```
Timestamps and volatile process/network data generate noise; focus on new accounts, jobs, listeners, changes to SSH and services.

## Deliberately excluded
No mass user password rotation, automatic disabling/deletion, service killing, `chattr +i`, SELinux disabling, broad package installation, direct iptables flush, or automated reboots. No automated restorations/watchdog that might hide a compromise or destroy evidence.
