#!/bin/bash

# Synopsis
#       Updates and Upgrades Ubuntu and write output to a log file.
# Description
#       Updates and Upgrades Ubuntu and write output to a log file.
# Example
#       ./update.sh
# Notes
#       NAME: update.sh
#       AUTHOR: gpaganini@aviva.com.br
#       CREATION DATE: 1 November 2023
#       MODIFIED DATE: 1 November 2023
#       VERSION: 1.0
#       CHANGE LOG:
#       V1.0, 1/11/2023 - Initial Version.

#Define variables
log_file="/var/log/apt/apt-upgrade.log"
current_date=$(date '+%d/%m/%Y %H:%M:%S')

# Write current date and time to the log
echo "=== Apt Update and Upgrade Log - $current_date ===" >> "$log_file"

# Update the package list
apt update -q -y >> "$log_file"

# Upgrade packages
apt upgrade -q -y >> "$log_file"

# Clean up obsolete packages
#apt autoremove -y >> "$log_file"

# Clean up cached package files
apt clean >> "$log_file"

# Get completion date and time
completion_date=$(date '+%d/%m/%Y %H:%M:%S')

echo "Apt update and upgrade completed on $completion_date system will reboot now" >> "$log_file"

reboot
#EOF