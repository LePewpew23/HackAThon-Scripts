#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/lib.sh"
need_root; source /etc/os-release
[[ "$ID" == ubuntu || "$ID" == linuxmint ]] || { echo 'Ubuntu/Mint only'; exit 1; }
require ufw
mode="${1:---preview}"
if [[ "$mode" == --preview ]]; then
 ufw status verbose; echo 'Team 21 guidance: SSH TCP/22 and HTTP TCP/80 (confirm ports and NEIGH first).'; exit 0
fi
[[ "$mode" == --apply ]] || { echo 'Usage: --preview|--apply'; exit 2; }
confirm 'Console access + scoring ports verified? Apply inbound rules WITHOUT reset?' || exit 1
ufw allow 22/tcp; ufw allow 80/tcp
ufw default deny incoming
ufw --force enable
ufw status verbose
echo 'Immediately verify SSH from a new connection and both NEIGH checks. Manual rollback via console: ufw disable.'
