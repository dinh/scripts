#!/bin/bash
# Variables
DISK=nvme
ADAPTER=enp0s3

# Values
HOST=$(hostname)
DISK_SPACE=$(df -h |grep $DISK | awk '{print $1 ": " $3 "/" $2 " (" $5 ") used"}')
RELEASE=$(cat /etc/arch-release)
KERNEL=$(uname -r)
IP=$(ip a | grep 'inet ' | grep $ADAPTER | awk '{print $2}' | cut -d '/' -f 1)
RAM=$(free -h | grep Mem | awk '{print $3 "/" $2 " used"}')
SWAP=$(free -h | grep Swap | awk '{print $3 "/" $2 " used"}')
SYSTEMCTL_STATUS=$(systemctl status | head -n 2 | grep State | awk '{print $2}')
SERVICES=(nginx teamcity owncloud mysqld)

# Functions
service_status () {
    systemctl list-unit-files |grep $1 > /dev/null
    if [ $? -eq 0 ]; then
        systemctl status $1 | grep Active | awk '{print $2 " " $3}'
    else
        echo "service not found"
    fi
}

echo "Welcome $USER@$HOST to $RELEASE ($KERNEL)" > /etc/motd

echo "" >> /etc/motd

echo "Status" >> /etc/motd
echo "> System: $SYSTEMCTL_STATUS" >> /etc/motd

echo "" >> /etc/motd

echo "Services" >> /etc/motd
for SERVICE in "${SERVICES[@]}"; do
    echo "> $SERVICE: $(service_status $SERVICE)" >> /etc/motd
done

echo "" >> /etc/motd

echo "Disk space" >> /etc/motd
echo "> $DISK_SPACE" >> /etc/motd

echo "" >> /etc/motd

echo "Memory" >> /etc/motd
echo "> Ram:  $RAM" >> /etc/motd
echo "> Swap: $SWAP" >> /etc/motd

echo "" >> /etc/motd

echo "Network" >> /etc/motd
echo "> IP: $IP ($ADAPTER)" >> /etc/motd

echo "" >> /etc/motd
