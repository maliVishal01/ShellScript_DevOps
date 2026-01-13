source config.conf
mkdir -p "$BACKUP_DIR"
echo "Taking backup of $WATCH_DIR"
tar -czf "$BACKUP_DIR/backup_$(date +%Y%m%d%H%M%S).tar.gz" "$WATCH_DIR" 2>/dev/null
echo "Backup completed"
