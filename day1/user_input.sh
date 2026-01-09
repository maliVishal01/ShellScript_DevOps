#!/bin/bash
echo "========USER INPUT Script ========"

read -p "enter your name : " Name 
read -p "Enter environment (dev/test/prod): " ENV
read -s -p "Enter secrete key: " SECRET
echo ""

echo "____________________________________"
echo "Name 		: $Name"
echo "Environment 	: $ENV"

if [ -z "$SECRET" ]; then 
	echo " Secrete key cannot be empty"
else 
	echo " yes Secrete key accepted "
fi 
















