#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Run as root: sudo ./main.sh"
  exit 1
fi

source config.conf
mkdir -p logs backups

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') : $1" >> "$LOG_FILE"
}

echo "Disaster Recovery System Started"
log "System started"

bash modules/backup.sh
bash modules/disk_monitor.sh
bash modules/service_monitor.sh
bash modules/file_monitor.sh

echo "Monitoring completed"
log "Monitoring completed"
