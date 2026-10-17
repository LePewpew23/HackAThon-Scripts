#!/usr/bin/env bash
# Team 21 toolkit setup (local copy, no package installation or hardening).
set -euo pipefail
src=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
dest=${1:-"$HOME/hpcc21-linux"}
mkdir -p "$dest"
if [[ $(cd "$dest" && pwd) == "$src" ]]; then
  echo 'Toolkit already at target directory.'
else
  cp -n "$src"/*.sh "$src"/*.conf "$dest"/
fi
chmod u+x "$dest"/*.sh
printf 'Linux toolkit ready at: %s
' "$dest"
echo 'No service configurations or accounts were changed.'
echo 'Next: cd to target directory; sudo ./baseline.sh; sudo ./user-hardening.sh'
