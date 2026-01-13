echo "========== PATCH STATUS =========="
if command -v apt >/dev/null; then
    apt list --upgradable 2>/dev/null | wc -l
elif command -v yum >/dev/null; then
    yum check-update | wc -l
else
    echo "Package manager not supported"
fi
echo ""
