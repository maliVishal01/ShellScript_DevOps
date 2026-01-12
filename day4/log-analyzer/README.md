Web Server Log Analyzer & Report Generator
📌 Project Overview

This project is a production-style Shell Script that analyzes web server access logs (Apache/Nginx) and generates a detailed traffic, error, and security report.

It is designed to simulate real DevOps & SRE workflows where engineers analyze logs to detect:

High traffic

Errors

Security attacks

Popular endpoints

This project demonstrates strong Linux + Shell Scripting + DevOps fundamentals.

🛠️ Features

✔ Counts total requests
✔ Finds top IP addresses
✔ Detects 4xx client errors
✔ Detects 5xx server errors
✔ Finds possible attackers
✔ Finds most requested URLs
✔ Generates daily report
✔ Stores logs in file
✔ Cron-ready for automation

📁 Project Structure
log-analyzer/
├── analyze_logs.sh
├── config.conf
├── sample_access.log
├── logs/
│   └── report.log
└── README.md

⚙️ Configuration – config.conf
LOG_FILE="./sample_access.log"
REPORT_FILE="./logs/report.log"
TOP_IP_COUNT=5


You can change:

Log file path

Report location

Number of top IPs

📄 Sample Log Format

The script supports Apache/Nginx style logs:

192.168.1.10 - - [10/Jan/2026:10:22:01] "GET /login HTTP/1.1" 200
192.168.1.11 - - [10/Jan/2026:10:22:03] "POST /login HTTP/1.1" 401

▶️ How to Run
chmod +x analyze_logs.sh
./analyze_logs.sh


The output will appear:

On terminal

Inside logs/report.log

⏰ Run Automatically (Cron)

To generate a report daily at 1 AM:

crontab -e
0 1 * * * /full/path/analyze_logs.sh

📊 Sample Output
Total Requests: 15000
Top IPs:
192.168.1.10 540
192.168.1.12 400

4xx Errors: 120
5xx Errors: 15

Possible Attackers:
192.168.1.11 -> 10 attempts

Most Requested URLs:
/login
/admin
/home
