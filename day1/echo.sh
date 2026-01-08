#!/bin/bash
LOG_FILE="./script_output.log"

echo " Shell script echo Demonstation" 

APP_NAME="DevOps-App"
ENVIRONMENT="Production"
STATUS="Running"

echo "application name : $APP_NAME"
echo "Environment : $ENVIRONMENT"
echo " status : $STATUS"

echo "Writing logs..."

echo "[$(date)] app: $APP_NAME started" >> "$LOG_FILE"
echo "[$(date)] Environment:  $ENVIRONMENT" >> "$LOG_FILE"
echo "[$(date)] status: $STATUS" >> "$LOG_FILE"

echo "Logs written to $LOG_FILE"
