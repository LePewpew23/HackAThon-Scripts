#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/lib.sh"
need_root; source /etc/os-release
[[ "$ID" == fedora ]] || { echo 'Fedora only'; exit 1; }
require firewall-cmd
mode="${1:---preview}"
if [[ "$mode" == --preview ]]; then firewall-cmd --list-all; echo 'Team 21 ignition: SSH TCP/22; HTTP service port MUST be verified (OpenWebUI may use a different port/reverse proxy).'; exit 0; fi
[[ "$mode" == --apply ]] || { echo 'Usage: --preview|--apply'; exit 2; }
confirm 'Console access and actual scored HTTP port verified? Add runtime SSH/HTTP access?' || exit 1
firewall-cmd --add-service=ssh
firewall-cmd --add-service=http
firewall-cmd --list-all
echo 'Runtime-only rules; verify NEIGH before making permanent. SELinux unchanged.'
