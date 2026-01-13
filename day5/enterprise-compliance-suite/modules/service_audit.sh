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
