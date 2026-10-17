#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/lib.sh"
need_root
run(){ echo; echo "===== $1 ====="; shift; "$@" 2>&1 || true; }
run_report baseline bash -c '
 echo "Date: $(date -Is) Host: $(hostname)";
 cat /etc/os-release; ip -br addr; ip route;
 echo ===USERS===; getent passwd; getent group;
 echo ===SUDOERS===; cat /etc/sudoers; find /etc/sudoers.d -maxdepth 1 -type f -exec sh -c '\''for f do echo "$f"; cat "$f"; done'\'' sh {} +;
 echo ===PORTS===; ss -tulpn; echo ===CONNECTIONS===; ss -tanp;
 echo ===SERVICES===; systemctl list-units --type=service --state=running --no-pager;
 echo ===TIMERS===; systemctl list-timers --all --no-pager;
 echo ===PROCESSES===; ps auxww;
 echo ===SSH_KEYS_PATHS===; find /root /home -name authorized_keys -type f -print 2>/dev/null;
 echo ===FIREWALL===; command -v ufw >/dev/null && ufw status verbose; command -v firewall-cmd >/dev/null && firewall-cmd --list-all;
 true'
