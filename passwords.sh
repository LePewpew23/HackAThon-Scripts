#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/lib.sh"
need_root
user="${1:-}"
if [[ ! "$user" =~ ^[a-z_][a-z0-9_-]*$ ]] || [[ "$user" == root ]]; then
 echo 'Usage: sudo ./passwords.sh plinktern|jmoney|APP_USER (approved account)' >&2; exit 2
fi
id "$user" >/dev/null || { echo "No user: $user"; exit 1; }
confirm "Rotate password for $user with console/recovery available?" || exit 1
passwd "$user"
echo 'VERIFY fresh login before closing your original session.'
if [[ "$user" == jmoney ]]; then echo 'IMMEDIATE: Update jmoney password in NEIGH scoring and verify check.'; fi
echo 'Password intentionally not printed or saved to a shell log.'
