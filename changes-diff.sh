#!/usr/bin/env bash
set -Eeuo pipefail
if (($#!=2)); then echo "Usage: $0 /path/to/old-report.txt /path/to/new-report.txt" >&2; exit 2; fi
[[ -r "$1" && -r "$2" ]] || { echo 'Reports unreadable' >&2; exit 1; }
diff -u -- "$1" "$2" || [[ $? == 1 ]]
