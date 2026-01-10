#!/bin/bash 

#################################################
# linux admin fundamental scripts 
# Practice all shell fundamentals

log_file="./admin_tools.log"

date=$(date "+%Y-%m-%d %H:%M:%S")

# login fun


log_msg() { 
	echo "$date : $1" >> "$log_file" 

	}

	# check root user 

	check_root()
	{ 
		if [ "$EUID" -ne 0 ]; then 
			echo " please run as root " 
			log_msg "Script failed: not root user" 
			exit 1 
		fi 

	} 

#-------------------------------
# Systemm Information 
#_______________________________

system_info() 
{
	 echo " ++++++++ System Info +++++++"
	 echo " Hostname	: $(hostname)"
	 echo " Os Version	: $(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2)" 
	 echo " Kernel 		: $(uname -r)"
	 echo " Uptime 		: $(uname -p)"
	 echo " CPU load 	: $(uptime | awk -F'load average:' '{ print $2 }')"
	 echo "Memory Usage 	:"
	 free -h 
	 echo "Disk Usage	:"
	 df -h /
	 log_msg " Viewd system Information" 
} 

#___________________________________________
#Disk Usage check 
#___________________________________________

disk_check() { 
	THRESHOLD=80
	USED=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')

	echo "Disk usage is : $USED%"

	if [ "USED" -ge "THRESHOLD" ]; then 
		echo "Warning : disk usage above $THRESHOLD%"
		log_msg "Diusk warning: usage $USED%"
	esle 
		echo " Disk usage is normal " 
		log_msg "Disk Usage normal : $USED%"
	fi
}

#___________________________________________
#User creation 
#___________________________________________


create_user()
{

	 read -p "enter username to create : " USERNAME

	 if [ -z "$USERNAME" ]; then 
		 echo " error : username cannot be empty " 
		 return 
	fi 


	 if id "$USERNAME" &>/dev/null; then 
		 echo "User already exists " 
		 log_msg "User creation failed : $USERNAME exists" 
	else
		useradd "$USERNAME"
		if [ $? -eq 0 ]; then 

		echo "$USERNAME:Password@123" | chpasswd
		echo " user $USERNAME created" 
		log_msg "User created: $USERNAME " 

	else 
		echo " failed to create user. did you use a space or invalid character ? " 
		log_msg "useradd command faild for: $USERNAME"
		fi
		
	fi
}

################################################
#service status check 
################################################

services_check() { 
	read -p "enter services name (nginx/docker.ssh): "service

	systemctl is-active "$services" &>/dev/null
	status=$?

	if [ "$status" -eq 0 ]; then 
		echo " services $service is running "
		log_msg "service running : $service" 
	else	
		echo " services $service is not running " 
		read -p "Do you want to start  it ? (yea/no) : "choice

		if [ "choice" == "yes" ]; then 
			systemctl start "$service"
			echo "service started " 
			log_msg "service started : $ service" 
		else 
			log_msg "services not started: $service" 
		fi 
	fi 

} 

#________________________________________________
# file cleanup (loop example ) 
# _______________________________________________


cleanup_logs ()
{
	 read -p "enter directory to clean logs : " DIR 

	 if [ ! -d "$DIR" ]; then 
		 echo " Directory does not exist" 
		 return 

	fi 

	for file in "$DIR"/*.log
	do 
		if [ -f "$file" ]; then 
			echo "deleting $file" 
			rm -f "$file" 
			log_msg "deleted log file : $file " 
		fi 
	done 

	echo " cleanup completed " 
}

#________________________________________________
# menu (case + loop ) 
# _______________________________________________

while true
do
	echo ""
	echo "+++++++++++++++ linux admin menu +++++++++++++++" 
	echo " 1. system information " 
	echo " 2. Disk Usage check" 
	echo " 3. Create User "
	echo " 4. Service Check " 
	echo " 5. Cleanup Log Files " 
	echo " 6. Exit " 
	echo "++++++++++++++++++++++++++++++++++++++++++++++++" 

	read -p "enter the choice " option 

	case $option in 
		1) system_info ;;
		2) disk_check ;;
		3) create_user ;;
		4) service_check ;;
		5) cleanup_logs ;;
		6) 
			echo " exiting...." 
			log_msg "script exited " 
			exit 0 
			;;
		*)
			echo " invalid option "  
			;;
	esac
done 

