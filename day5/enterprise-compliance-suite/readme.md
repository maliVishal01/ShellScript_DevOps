
This repository contains a one-click setup script that builds a complete Linux Enterprise Compliance and Audit System.

The idea behind this project is simple:
instead of manually creating folders, scripts, and configurations, you run a single setup file and it prepares everything for you in a clean, professional structure.

This is how real DevOps teams bootstrap internal tools.

What this script does

When you run setup_enterprise_suite.sh, it will:

Create the full project directory structure

Generate all required shell scripts

Create the configuration file

Set proper file permissions

Prepare folders for logs and reports

Make the project ready to run immediately

After this, you can directly execute the compliance scanner without writing any code yourself.

What is the Enterprise Compliance Suite

The system created by this setup script performs:

System inventory collection

Security audit (open ports, sudo users, risky permissions)

Disk usage compliance checks

User activity and login auditing

Service status validation

Patch and update checks

Centralized compliance reporting

It is designed to simulate how companies prepare Linux servers for security and audit reviews.

Folder structure created

After running the setup script, you will get:

<img width="507" height="313" alt="{4C1FA2F9-2F8B-43BB-906A-9371ACB2A6D4}" src="https://github.com/user-attachments/assets/f771b55a-ea7e-47b0-8c9f-508d4df5fd31" />



Everything is separated cleanly so each part of the audit can be maintained or extended later.

How to use

First, make the setup script executable:

chmod +x setup_enterprise_suite.sh


Then run it:

./setup_enterprise_suite.sh


This will create the enterprise-compliance-suite folder with all files inside.

Now move into the project and run the scanner:

cd enterprise-compliance-suite
./main.sh


A compliance report will be generated inside:

reports/compliance_report.txt
