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
