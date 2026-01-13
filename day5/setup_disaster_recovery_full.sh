#!/bin/bash

PROJECT="disaster-recovery-system"

echo "Creating Disaster Recovery and Self-Healing System"

mkdir -p $PROJECT/modules
mkdir -p $PROJECT/logs
mkdir -p $PROJECT/backups

############################
# config.conf
############################
cat > $PROJECT/config.conf <<EOF
WATCH_DIR="/opt/critical_data"
BACKUP_DIR="./backups"
CRITICAL_SERVICES="nginx ssh"
DISK_LIMIT=80
LOG_FILE="./logs/recovery.log"
EOF

############################
# main.sh
############################
cat > $PROJECT/main.sh <<'EOF'
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
EOF

############################
# backup.sh
############################
cat > $PROJECT/modules/backup.sh <<'EOF'
source config.conf
mkdir -p "$BACKUP_DIR"
echo "Taking backup of $WATCH_DIR"
tar -czf "$BACKUP_DIR/backup_$(date +%Y%m%d%H%M%S).tar.gz" "$WATCH_DIR" 2>/dev/null
echo "Backup completed"
EOF

############################
# restore.sh
############################
cat > $PROJECT/modules/restore.sh <<'EOF'
source config.conf
LATEST=$(ls -t "$BACKUP_DIR"/*.tar.gz 2>/dev/null | head -1)
if [ -z "$LATEST" ]; then
    echo "No backup available"
    exit 1
fi
echo "Restoring data"
rm -rf "$WATCH_DIR"
tar -xzf "$LATEST" -C /
echo "Restore completed"
EOF

############################
# disk_monitor.sh
############################
cat > $PROJECT/modules/disk_monitor.sh <<'EOF'
source config.conf
USAGE=$(df "$WATCH_DIR" | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$USAGE" -ge "$DISK_LIMIT" ]; then
    echo "Disk usage high: $USAGE percent"
    bash modules/backup.sh
fi
EOF

############################
# service_monitor.sh
############################
cat > $PROJECT/modules/service_monitor.sh <<'EOF'
source config.conf
for svc in $CRITICAL_SERVICES
do
    systemctl is-active "$svc" > /dev/null
    if [ $? -ne 0 ]; then
        echo "Restarting $svc"
        systemctl restart "$svc"
    fi
done
EOF

############################
# file_monitor.sh
############################
cat > $PROJECT/modules/file_monitor.sh <<'EOF'
source config.conf
if [ ! -d "$WATCH_DIR" ]; then
    echo "Data directory missing, restoring"
    bash modules/restore.sh
fi
EOF

############################
# Permissions
############################
chmod +x $PROJECT/main.sh
chmod +x $PROJECT/modules/*.sh

############################
# Create protected data
############################
if [ ! -d "/opt/critical_data" ]; then
    sudo mkdir -p /opt/critical_data
    sudo bash -c 'echo "This is critical business data" > /opt/critical_data/data.txt'
fi

echo ""
echo "Project created successfully"
echo "Protected data folder: /opt/critical_data"
echo "Test file: /opt/critical_data/data.txt"
echo ""
echo "Run:"
echo "cd $PROJECT"
echo "sudo ./main.sh"

