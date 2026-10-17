#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/lib.sh"
need_root
run_report egress bash -c '
 echo ====CONNECTIONS====; ss -tanp;
 echo ====ROUTES====; ip route;
 echo ====DNS====; cat /etc/resolv.conf;
 echo ====FIREWALL====;
 command -v ufw >/dev/null && ufw status verbose;
 command -v firewall-cmd >/dev/null && firewall-cmd --list-all;
 command -v nft >/dev/null && nft list ruleset;
 echo ====DUAL_USE_TOOLS====;
 for tool in nc ncat netcat socat telnet nmap; do command -v "$tool" || true; done;
 echo ====TEMP_CONTENTS====; ls -la /tmp /var/tmp /dev/shm;
 true'
echo 'Read-only: does NOT delete files/remove tools/deny outbound. Verify dependencies, scoring, updates, and SIEM before applying manual changes.'
