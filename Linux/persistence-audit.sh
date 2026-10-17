#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/lib.sh"
need_root
run_report persistence bash -c '
 echo ====SSH_KEYS====; find /root /home -type f -name authorized_keys -print -exec cat {} \; 2>/dev/null;
 echo ====USERS====; getent passwd; echo ====GROUPS====; getent group;
 echo ====ROOT_CRON====; crontab -l 2>&1;
 echo ====SYSTEM_CRON====; ls -al /etc/cron* /var/spool/cron* 2>&1;
 echo ====TIMERS====; systemctl list-timers --all --no-pager;
 echo ====CUSTOM_UNITS====; find /etc/systemd/system -type f -print 2>/dev/null;
 echo ====SUID_SGID====; find /usr /bin /sbin -type f -perm /6000 -print 2>/dev/null;
 echo ====CAPABILITIES====; command -v getcap >/dev/null && getcap -r /usr /bin /sbin 2>/dev/null;
 echo ====LISTENING====; ss -tulpn; echo ====ESTABLISHED====; ss -tanp;
 echo ====TEMP_DIRECTORY_LISTING====; ls -la /tmp /var/tmp /dev/shm;
 echo ====AUTOSTART====; ls -la /etc/rc.local /etc/profile.d /etc/ld.so.preload 2>&1;
 true'
