#!/bin/bash
CONFIG_FILE="./config.conf"

if [ ! -f "$CONFIG_FILE" ]; then
	echo " config file missing"
	exit 1 
fi 

source "$CONFIG_FILE"
mkdir -p logs 
 
DATE=$(date "+%y-%m-%d %h:%m:%s")

#____________________________
# logging Function 
# ___________________________

log() {
	echo "$DATE : $1" >> "LOG_FILE"

}

#____________________________
#CPU CHECK
#____________________________

check_cpu()
{
	 IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d. -f1)
	 CPU_USED=$((100 - IDLE))

	 echo "cpu Usage : $CPU_USED%"
	 log " cpu Usage : $CPU_USED%"

	 if [ "$CPU_USED" -ge "$CPU_THRESHOLD" ]; then 
		 log "Alert : high cpu usage " 
		 echo " high cpu usage "

	fi 
} 

#____________________________
#Memory check
#----------------------------
check_memory() {
    MEM_USED=$(free | awk '/Mem/ {printf "%.0f", $3/$2 * 100}')

    echo "Memory Usage: $MEM_USED%"
    log "Memory Usage: $MEM_USED%"

    if [ "$MEM_USED" -ge "$MEM_THRESHOLD" ]; then
        log "ALERT: High Memory Usage"
        echo "High Memory usage"
    fi
}
#____________________________
#Disk Check 
#____________________________

check_disk () 
{ 
	df -h | grep '^/dev/' | while read line 
	do 
		USAGE=$(echo "$line" | awk '{print $5}' | sed 's/%//')
		MOUNT=$(echo "$line" | awk '{print $6}')

		echo "disk $MOUNT: $USAGE%"
		log  "disk $MOUNT: $USAGE%"

	if [ "$USAGE" -ge "$DISK_THRESHOLD" ]; then 
		log "Alert: Disk full on $MOUNT"
		echo " Disk critical on $MOUNT"
	fi 
done 
} 

#____________________________
#Services Check
#____________________________


check_services()
{
	for svc in $SERVICES 
	do 
		systemctl is-active "$svc" &>/dev/null

		if [ $? -eq 0 ]; then 
			echo "service $svc running "
			log "services running : $svc " 

		else 
			echo " services $svc stoppedz"
			log "alert : service stopped : $svc"
		fi
	done
}

#____________________________
#Network Check 
#____________________________

check_network()
{
	ping -c 2 google.com &>/dev/null

	if [ $? -eq 0 ]; then 
		echo "Network ok" 
		echo "network ok"

	else 
		echo " network down "
		log "alert : network down " 
	fi 
} 

#____________________________
#MAIN
#____________________________

echo "==== Health check started ===="
log "Health check started "

check_cpu
check_memory
check_disk
check_services
check_network

echo "===== helath check completed ====="
log " health check completed " 

