#!/usr/bin/env bash
# Team 21: review Linux accounts and optionally lock one account.
set -euo pipefail
if (( EUID != 0 )); then echo "Run with sudo" >&2; exit 1; fi
umask 077
printf '
Local interactive accounts:
'
awk -F: '$7 ~ /(bash|zsh|fish|sh)$/ {print $1 " UID=" $3 " SHELL=" $7}' /etc/passwd
printf '
Privileged groups:
'
for g in sudo wheel; do getent group "$g" || :; done
printf '
UID 0 accounts:
'
awk -F: '$3==0 {print $1}' /etc/passwd
[[ ${1:-} == --lock ]] || { echo '
Audit complete. To lock one reviewed account: sudo ./user-hardening.sh --lock USER'; exit 0; }
user=${2:-}
[[ $user =~ ^[a-zA-Z_][a-zA-Z0-9_.-]*$ ]] || { echo 'Provide a valid username' >&2; exit 1; }
case "$user" in root|plinktern|jmoney) echo 'Protected account, refusing.' >&2; exit 1;; esac
entry=$(getent passwd "$user") || { echo 'Account not found' >&2; exit 1; }
uid=$(cut -d: -f3 <<< "$entry")
(( uid >= 1000 )) || { echo 'System account: manual investigation required.' >&2; exit 1; }
if [[ $user == "$(id -un "${SUDO_UID:-0}" 2>/dev/null || true)" ]]; then echo 'Cannot lock your own account.' >&2; exit 1; fi
read -r -p "Type LOCK $user to lock password-based login (SSH keys may still work): " answer
[[ $answer == "LOCK $user" ]] || { echo 'Canceled.'; exit 0; }
mkdir -p /root/hpcc-reports
printf '%s locked-password %s
' "$(date -Is)" "$user" >> /root/hpcc-reports/account-actions.log
passwd -l "$user"
echo 'Password locked. Inspect SSH keys and active sessions separately. To reverse: passwd -u USER (only after resetting a safe password).'
