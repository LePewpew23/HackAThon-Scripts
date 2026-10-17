#!/usr/bin/env bash
set -Eeuo pipefail
umask 077
need_root(){ (( EUID == 0 )) || { echo 'Run with sudo/root' >&2; exit 1; }; }
require(){ command -v "$1" >/dev/null || { echo "Missing required command: $1" >&2; exit 1; }; }
confirm(){ local reply; read -r -p "$1 Type YES: " reply; [[ "$reply" == YES ]]; }
report_dir(){ local d=/root/hpcc-reports; mkdir -p "$d"; chmod 700 "$d"; printf '%s' "$d"; }
run_report(){ local name=$1; shift; local out; out="$(report_dir)/${name}-$(hostname)-$(date +%Y%m%d-%H%M%S).txt"; ( "$@" ) >"$out" 2>&1 || true; chmod 600 "$out"; echo "Report: $out"; }
