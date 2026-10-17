#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/lib.sh"
need_root
mode="${1:---check}"
case "$mode" in --check|--restart) ;; *) echo 'Usage: service-watchdog.sh --check|--restart' >&2; exit 2;; esac
host=$(hostname -s)
case "$host" in guidance) service='ssh'; url='http://127.0.0.1/' ;; ignition) service='ssh'; url='http://127.0.0.1/';; *) echo "Host $host: no watchdog preset; nothing changed"; exit 2;; esac
if [[ "$mode" == --restart ]]; then
 confirm 'Allow restart ONLY of the chosen failed service after review?' || exit 1
fi
for svc in "$service"; do
 if systemctl is-active --quiet "$svc" || { [[ "$svc" == ssh ]] && systemctl is-active --quiet sshd; }; then
  echo "OK: SSH unit active";
 else
  echo "WARNING: SSH unit inactive; NEVER automatically restart/stop SSH without console verification";
 fi
done
if command -v curl >/dev/null; then
 code=$(curl --max-time 5 -sS -o /dev/null -w '%{http_code}' "$url" || true)
 echo "HTTP at $url => $code (verify expected response via NEIGH)"
else echo 'curl not installed'; fi
if [[ "$mode" == --restart ]]; then
 echo 'No automatic restarts of HTTP/OpenWebUI: service unit names/dependencies must be confirmed on actual machine.'
fi
