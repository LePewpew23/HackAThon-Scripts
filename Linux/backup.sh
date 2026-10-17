#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/lib.sh"
source "$(dirname "$0")/team21.conf"
need_root; require tar
ROOT=/root/hpcc-backups; mkdir -p "$ROOT"; chmod 700 "$ROOT"
NAME="$(hostname)-$(date +%Y%m%d-%H%M%S)"
ARCHIVE="$ROOT/$NAME.tar.gz"
paths=(etc/ssh etc/passwd etc/group etc/sudoers)
for path in etc/sudoers.d etc/nginx etc/apache2 etc/httpd var/www etc/systemd/system etc/containers; do [[ -e "/$path" ]] && paths+=("$path"); done
tar -C / -czf "$ARCHIVE" "${paths[@]}"
chmod 600 "$ARCHIVE"; sha256sum "$ARCHIVE" > "$ARCHIVE.sha256"; chmod 600 "$ARCHIVE.sha256"
echo "Created: $ARCHIVE"
echo 'NOTE: database backups require an authorized application-specific logical dump; none is created by this script.'
if [[ "${1:-}" == --to-blackbox ]]; then
 require ssh; require scp
 : "${BLACKBOX_USER:?Set BLACKBOX_USER to approved blackbox username}"
 remote="${BLACKBOX_USER}@${BLACKBOX_HOST}"
 # root executes SSH: preconfigure and verify host keys, never disable strict checking
 ssh -o StrictHostKeyChecking=yes "$remote" 'umask 077; mkdir -p ~/hpcc-backups; chmod 700 ~/hpcc-backups'
 scp -o StrictHostKeyChecking=yes -p "$ARCHIVE" "$ARCHIVE.sha256" "$remote:hpcc-backups/"
 echo 'Transferred; verify hash and restoration before trusting backup.'
fi
