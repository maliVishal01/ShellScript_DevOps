#!/bin/bash

####################################################
# Project : NGINX Web Server Log Analyzer
# Author  : DevOps Engineer
####################################################

CONFIG="./config.conf"

if [ ! -f "$CONFIG" ]; then
    echo "❌ Config file missing"
    exit 1
fi

source "$CONFIG"
mkdir -p logs

DATE=$(date "+%Y-%m-%d %H:%M:%S")

log() {
    echo "$DATE : $1" >> "$REPORT_FILE"
}

if [ ! -f "$LOG_FILE" ]; then
    echo "❌ Log file not found: $LOG_FILE"
    exit 1
fi

echo "===== NGINX LOG ANALYSIS STARTED ====="
log "Log analysis started"

############################################
# Total Requests
############################################
TOTAL=$(wc -l < "$LOG_FILE")
echo "Total Requests: $TOTAL"
log "Total Requests: $TOTAL"

############################################
# Top IP Addresses
############################################
echo "Top $TOP_IP_COUNT IP addresses:"
log "Top $TOP_IP_COUNT IP addresses:"

awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n $TOP_IP_COUNT | while read line
do
    echo "$line"
    log "$line"
done

############################################
# 4xx Errors
############################################
ERROR4=$(awk '$9 ~ /^4/ {count++} END {print count+0}' "$LOG_FILE")
echo "Total 4xx Errors: $ERROR4"
log "Total 4xx Errors: $ERROR4"

############################################
# 5xx Errors
############################################
ERROR5=$(awk '$9 ~ /^5/ {count++} END {print count+0}' "$LOG_FILE")
echo "Total 5xx Errors: $ERROR5"
log "Total 5xx Errors: $ERROR5"

############################################
# Attack Detection (401 & 403)
############################################
echo "Possible Attackers:"
log "Possible Attackers:"

awk '$9 ~ /401|403/ {print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | awk '$1 > 2 {print $2 " -> " $1 " attempts"}' | while read line
do
    echo "$line"
    log "$line"
done

############################################
# Most Requested URLs
############################################
echo "Most Requested URLs:"
log "Most Requested URLs:"

awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -5 | while read line
do
    echo "$line"
    log "$line"
done

############################################
# End
############################################
echo "===== LOG ANALYSIS COMPLETED ====="
log "Log analysis completed"

