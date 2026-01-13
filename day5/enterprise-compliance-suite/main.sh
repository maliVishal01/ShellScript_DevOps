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
