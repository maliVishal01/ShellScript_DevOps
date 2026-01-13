source config.conf
if [ ! -d "$WATCH_DIR" ]; then
    echo "Data directory missing, restoring"
    bash modules/restore.sh
fi
