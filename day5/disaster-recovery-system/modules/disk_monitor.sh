source config.conf
USAGE=$(df "$WATCH_DIR" | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$USAGE" -ge "$DISK_LIMIT" ]; then
    echo "Disk usage high: $USAGE percent"
    bash modules/backup.sh
fi
