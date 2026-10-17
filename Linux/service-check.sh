#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/lib.sh"
# usage: ./service-check.sh http://127.0.0.1:80/ [expected substring]
url=${1:-http://127.0.0.1/}; expected=${2:-}
require curl
code=$(curl --max-time 6 --connect-timeout 3 -sS -L -o /tmp/hpcc-service-check-"$$" -w '%{http_code}' "$url") || { echo "FAIL: unreachable $url"; exit 1; }
trap 'rm -f /tmp/hpcc-service-check-"$$"' EXIT
if [[ "$code" != 200 ]]; then echo "WARN: HTTP $code from $url (verify expected scoring status)"; exit 2; fi
if [[ -n "$expected" ]] && ! grep -Fq -- "$expected" /tmp/hpcc-service-check-"$$"; then echo "FAIL: expected content absent from $url"; exit 3; fi
echo "PASS: HTTP $code from $url" 
