#!/bin/bash

# System Monitor Script
LOGFILE=~/system_monitor.log
ALERT_LOG=~/alerts.log
TIMESTAMP=$(date '+%Y-%m-%d %H:%M')

# CPU usage (idle % subtracted from 100)
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')

# Memory usage
MEM=$(free -m | awk '/Mem:/ {printf "%.1f", $3/$2 * 100}')

# Disk usage (root partition)
DISK=$(df -h / | awk 'NR==2 {print $5}')

# Log it
echo "$TIMESTAMP | CPU: $CPU% | MEM: $MEM% | DISK: $DISK" >> $LOGFILE
echo "Logged: $TIMESTAMP | CPU: $CPU% | MEM: $MEM% | DISK: $DISK"

# Alert if CPU over 80%
if (( $(echo "$CPU > 80" | bc -l) )); then
    echo "$TIMESTAMP | ALERT: CPU usage is $CPU%" >> $ALERT_LOG
    echo "ALERT written to $ALERT_LOG"
fi
