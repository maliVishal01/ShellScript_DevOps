#!/bin/bash

PROJECT="enterprise-compliance-suite"

echo "Creating Enterprise Compliance Suite..."

mkdir -p $PROJECT/modules
mkdir -p $PROJECT/logs
mkdir -p $PROJECT/reports

########################
# config.conf
########################
cat > $PROJECT/config.conf <<EOF
REQUIRED_SERVICES="nginx ssh cron"
DISK_LIMIT=80
INACTIVE_DAYS=30
REPORT_FILE="./reports/compliance_report.txt"
LOG_FILE="./logs/suite.log"
EOF

########################
# main.sh
########################
cat > $PROJECT/main.sh <<'EOF'
#!/bin/bash
source config.conf
mkdir -p logs reports

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') : $1" >> "$LOG_FILE"
}

echo "===== ENTERPRISE COMPLIANCE SCAN STARTED ====="
log "Compliance scan started"

> "$REPORT_FILE"

bash modules/system_inventory.sh >> "$REPORT_FILE"
bash modules/security_audit.sh >> "$REPORT_FILE"
bash modules/disk_audit.sh >> "$REPORT_FILE"
bash modules/user_audit.sh >> "$REPORT_FILE"
bash modules/service_audit.sh >> "$REPORT_FILE"
bash modules/patch_audit.sh >> "$REPORT_FILE"

echo "===== SCAN COMPLETED ====="
log "Compliance scan completed"
echo "Report saved to $REPORT_FILE"
EOF

########################
# system_inventory.sh
########################
cat > $PROJECT/modules/system_inventory.sh <<'EOF'
echo "========== SYSTEM INVENTORY =========="
echo "Hostname: $(hostname)"
echo "OS: $(grep PRETTY_NAME /etc/os-release | cut -d= -f2)"
echo "Kernel: $(uname -r)"
echo "IP Address: $(hostname -I)"
echo "CPU: $(lscpu | grep 'Model name' | cut -d: -f2)"
echo "RAM: $(free -h | awk '/Mem/ {print $2}')"
echo ""
EOF

########################
# security_audit.sh
########################
cat > $PROJECT/modules/security_audit.sh <<'EOF'
echo "========== SECURITY AUDIT =========="
echo "Open Network Ports:"
ss -tuln | awk 'NR>1 {print $5}'
echo ""
echo "Sudo Users:"
getent group sudo | cut -d: -f4
echo ""
echo "World Writable Files (Top 10):"
find / -xdev -type f -perm -0002 2>/dev/null | head -10
echo ""
EOF

########################
# disk_audit.sh
########################
cat > $PROJECT/modules/disk_audit.sh <<'EOF'
source config.conf
echo "========== DISK COMPLIANCE =========="
df -h | grep '^/dev/' | while read line
do
    USAGE=$(echo "$line" | awk '{print $5}' | sed 's/%//')
    MOUNT=$(echo "$line" | awk '{print $6}')
    if [ "$USAGE" -ge "$DISK_LIMIT" ]; then
        echo "CRITICAL: $MOUNT usage is $USAGE%"
    else
        echo "OK: $MOUNT usage is $USAGE%"
    fi
done
echo ""
EOF

########################
# user_audit.sh
########################
cat > $PROJECT/modules/user_audit.sh <<'EOF'
echo "========== USER COMPLIANCE =========="
while IFS=: read -r user _ uid _ _ home shell
do
    if [ "$uid" -ge 1000 ] && [ "$shell" != "/usr/sbin/nologin" ]; then
        lastlog -u "$user" | tail -1
    fi
done < /etc/passwd
echo ""
EOF

########################
# service_audit.sh
########################
cat > $PROJECT/modules/service_audit.sh <<'EOF'
source config.conf
echo "========== SERVICE COMPLIANCE =========="
for svc in $REQUIRED_SERVICES
do
    systemctl is-active "$svc" &>/dev/null
    if [ $? -eq 0 ]; then
        echo "$svc : RUNNING"
    else
        echo "$svc : NOT RUNNING"
    fi
done
echo ""
EOF

########################
# patch_audit.sh
########################
cat > $PROJECT/modules/patch_audit.sh <<'EOF'
echo "========== PATCH STATUS =========="
if command -v apt >/dev/null; then
    apt list --upgradable 2>/dev/null | wc -l
elif command -v yum >/dev/null; then
    yum check-update | wc -l
else
    echo "Package manager not supported"
fi
echo ""
EOF

########################
# Permissions
########################
chmod +x $PROJECT/main.sh
chmod +x $PROJECT/modules/*.sh

echo "Enterprise Compliance Suite created successfully"
echo "Run it using:"
echo "cd $PROJECT && ./main.sh"

