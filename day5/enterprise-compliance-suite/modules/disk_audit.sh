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
