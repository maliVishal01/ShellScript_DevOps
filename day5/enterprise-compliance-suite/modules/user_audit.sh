echo "========== USER COMPLIANCE =========="
while IFS=: read -r user _ uid _ _ home shell
do
    if [ "$uid" -ge 1000 ] && [ "$shell" != "/usr/sbin/nologin" ]; then
        lastlog -u "$user" | tail -1
    fi
done < /etc/passwd
echo ""
