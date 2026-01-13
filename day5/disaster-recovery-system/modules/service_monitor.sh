source config.conf
for svc in $CRITICAL_SERVICES
do
    systemctl is-active "$svc" > /dev/null
    if [ $? -ne 0 ]; then
        echo "Restarting $svc"
        systemctl restart "$svc"
    fi
done
