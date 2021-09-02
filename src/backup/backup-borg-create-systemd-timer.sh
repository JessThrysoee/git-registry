#!/bin/bash

service="git-registry"
workdir="$PWD"
script="$workdir/backup-borg.sh create"

# https://www.freedesktop.org/software/systemd/man/systemd.time.html#Calendar%20Events
# systemd-analyze calendar --iterations=5 '03:00'
on_calendar="03:00"

# ---

etc="/etc/systemd/system/"


sudo tee $etc/$service-backup@.service >/dev/null <<EOF
[Unit]
Description=$service backup
 
[Service]
Type=simple
Nice=19
IOSchedulingClass=2
IOSchedulingPriority=7
User=%i
WorkingDirectory=$workdir
ExecStart=$script
EOF


sudo tee $etc/$service-backup@.timer >/dev/null <<EOF
[Unit]
Description=$service backup
 
[Timer]
WakeSystem=false
OnCalendar=$on_calendar
RandomizedDelaySec=10min
 
[Install]
WantedBy=timers.target
EOF


sudo systemctl daemon-reload
sudo systemctl enable --now "$service-backup@$USER.timer"

echo "See schedule with: sudo systemctl list-timers"
echo "Run once for tesing: sudo systemctl start $service-backup@$USER.service"
echo "See log with: sudo journalctl -u $service-backup@$USER.service"

