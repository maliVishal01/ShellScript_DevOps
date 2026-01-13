Linux Production Troubleshooter

This project is a simple but practical Linux troubleshooting tool written in shell script.
It simulates how system administrators and DevOps engineers quickly check the health of a Linux server when something goes wrong.

Instead of manually running multiple commands, this script collects the most important system information and generates a single report that can be reviewed or shared.

What this tool does

The script checks and reports on:

Disk usage and partitions running out of space

Failed system services

Dangerous file permissions (world-writable files)

Recent critical system errors from system logs

A short health summary

All of this information is written into a single file so it can be archived or reviewed later.

Project structure
linux-troubleshooter/
├── check.sh
└── report.txt


check.sh is the main script

report.txt is generated after the script runs

How it works

When you run the script, it executes standard Linux diagnostic commands such as:

df for disk usage

systemctl for service status

find for permission checks

journalctl for system errors

The output from these commands is collected and written into report.txt in a clean, readable format.

This is similar to what an on-call engineer would do during a production incident.

How to run

Make the script executable:

chmod +x check.sh


Run it with root privileges so it can read system logs and files:

sudo ./check.sh


View the report:

cat report.txt

Sample output

The report will look like this:

Linux Production Health Report
Generated on: 2026-01-12

Disk Status
Partitions above 80% usage:
...

Service Status
...

World Writable Files
...

Recent System Errors
...

Summary
All disks are within safe limits.
No failed services detected.

Why this project is useful

This tool demonstrates real-world Linux operations skills:

Understanding of disk and storage issues

Service troubleshooting

Security awareness

Log analysis

Automation using shell scripting

It is a good example of how DevOps and system engineers diagnose problems on live servers.

Use cases

College or training project

Linux administration practice

First-level server health checks

Incident investigation
