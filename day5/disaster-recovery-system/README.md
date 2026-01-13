🛡️ Disaster Recovery & Self-Healing Automation System
(Shell Script Based Enterprise DevOps Project)
📌 Project Overview

This project is a Linux-based Disaster Recovery and Self-Healing Automation System built using Shell Scripting.
It continuously monitors critical system components and automatically performs backup, recovery, disk monitoring, and service healing without manual intervention.

The goal of this project is to simulate how modern cloud and enterprise infrastructure handles failures automatically.

🚀 Key Features

✔ Automatic backup of critical data
✔ Auto restore if data is deleted
✔ Disk usage monitoring
✔ Self-healing of failed services
✔ Log generation for auditing
✔ Fully configurable
✔ Cron-ready for automation
✔ Enterprise-style modular design

🧠 Real-World Use Case

This system represents how companies like:

Amazon AWS

Google Cloud

Banks

Data Centers

protect servers from:

Disk full errors

Application crashes

Accidental file deletion

Service failures

🗂️ Project Structure
disaster-recovery-system/
├── main.sh
├── config.conf
├── modules/
│   ├── backup.sh
│   ├── restore.sh
│   ├── disk_monitor.sh
│   ├── service_monitor.sh
│   └── file_monitor.sh
├── backups/
├── logs/
│   └── recovery.log

⚙️ Configuration – config.conf
Variable	Description
WATCH_DIR	Folder to protect
BACKUP_DIR	Backup storage
CRITICAL_SERVICES	Services to monitor
DISK_LIMIT	Max allowed disk usage
LOG_FILE	Log file location

Example:

WATCH_DIR="$HOME/important_data"
BACKUP_DIR="./backups"
CRITICAL_SERVICES="nginx ssh"
DISK_LIMIT=80
LOG_FILE="./logs/recovery.log"

🧰 Resource Requirements
Hardware
Resource	Requirement
RAM	2 GB minimum
Disk	5 GB free
CPU	Any modern CPU
Software

Linux (Ubuntu / Debian / CentOS)

Bash Shell

Nginx (optional)

SSH service

tar, cron, systemctl

▶ How to Run
Step 1

Create the data directory:

mkdir -p $HOME/important_data

Step 2

Run the system:

cd disaster-recovery-system
./main.sh

⏰ Automate using Cron

Run every 10 minutes:

crontab -e
*/10 * * * * /path/disaster-recovery-system/main.sh

📄 Sample Output
CRITICAL: Disk usage high
Restarting nginx
Backup completed
Data restored from backup_20260110.tar.gz
