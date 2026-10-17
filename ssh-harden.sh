#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/lib.sh"
need_root
require sshd
CONFIG=/etc/ssh/sshd_config
[[ -f "$CONFIG" ]] || { echo 'SSH config not found'; exit 1; }
BACKUP="${CONFIG}.hpcc.$(date +%Y%m%d-%H%M%S).bak"
cp -a "$CONFIG" "$BACKUP"
echo "Config backup: $BACKUP"
echo 'Existing relevant directives:'
grep -En '^[[:space:]]*(PermitRootLogin|PermitEmptyPasswords|AllowUsers|DenyUsers|PasswordAuthentication)' "$CONFIG" || true
# Avoid append conflicts with system OpenSSH first-value semantics. Keep action manual and validated.
echo 'Recommended after reviewing active Match blocks: PermitRootLogin no; PermitEmptyPasswords no.'
echo 'Do not use AllowUsers until both plinktern and jmoney scoring access have been verified.'
echo 'No changes were applied automatically.'
sshd -t && echo 'Current SSH configuration syntax: OK'
echo 'After editing: sshd -t && systemctl reload sshd (Fedora) OR systemctl reload ssh (Ubuntu).'
