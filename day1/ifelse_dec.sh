#!/bin/bash

read -p "Enter disk usage percentage: " DISK

if [ "$DISK" -ge 90 ]; then
    echo " CRITICAL: Disk usage very high"
elif [ "$DISK" -ge 75 ]; then
    echo "WARNING: Disk usage high"
elif [ "$DISK" -ge 50 ]; then
    echo "INFO: Disk usage normal"
else
    echo " Disk usage is safe"
fi

