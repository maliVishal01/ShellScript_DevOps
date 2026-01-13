#!/bin/bash

REPORT="report.txt"
DATE=$(date "+%Y-%m-%d %H:%M:%S")

echo "Linux Production Health Report" > "$REPORT"
echo "Generated on: $DATE" >> "$REPORT"
echo "----------------------------------------" >> "$REPORT"

########################################
# Disk Status
########################################
echo "" >> "$REPORT"
echo "Disk Status" >> "$REPORT"
echo "------------" >> "$REPORT"

df -h >> "$REPORT"

echo "" >> "$REPORT"
echo "Partitions above 80% usage:" >> "$REPORT"

df -h | awk 'NR>1 {gsub("%","",$5); if($5 > 80) print $1 " mounted on " $6 " is at " $5 "%"}' >> "$REPORT"

########################################
# Service Status
########################################
echo "" >> "$REPORT"
echo "Service Status" >> "$REPORT"
echo "--------------" >> "$REPORT"

systemctl --failed >> "$REPORT"

########################################
# Permission Issues
########################################
echo "" >> "$REPORT"
echo "World Writable Files (Security Risk)" >> "$REPORT"
echo "----------------------------------" >> "$REPORT"

find / -xdev -type f -perm -0002 2>/dev/null | head -20 >> "$REPORT"

########################################
# Recent System Errors
########################################
echo "" >> "$REPORT"
echo "Recent System Errors" >> "$REPORT"
echo "--------------------" >> "$REPORT"

journalctl -p 3 -xb --no-pager | head -20 >> "$REPORT"

########################################
# Summary
########################################
echo "" >> "$REPORT"
echo "Summary" >> "$REPORT"
echo "-------" >> "$REPORT"

HIGH_DISK=$(df -h | awk 'NR>1 {gsub("%","",$5); if($5 > 80) print $0}')

if [ -n "$HIGH_DISK" ]; then
    echo "Warning: One or more disks are above 80% usage." >> "$REPORT"
else
    echo "All disks are within safe usage limits." >> "$REPORT"
fi

FAILED_SERVICES=$(systemctl --failed | grep loaded)

if [ -n "$FAILED_SERVICES" ]; then
    echo "Warning: Some system services have failed." >> "$REPORT"
else
    echo "No failed system services detected." >> "$REPORT"
fi

echo "" >> "$REPORT"
echo "End of report." >> "$REPORT"

echo "Health check completed. See report"
