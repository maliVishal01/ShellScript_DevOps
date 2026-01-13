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
