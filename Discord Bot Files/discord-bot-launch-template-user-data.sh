#!/bin/bash

# 1. Create a 1GB Swap File immediately 
# This provides "emergency RAM" so the instance doesn't crash during updates.
fallocate -l 1G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile swap swap defaults 0 0' >> /etc/fstab

# 2. Disable memory-heavy services not needed for a headless bot
# Stop and purge fwupd (the memory hog you found) and snapd
systemctl stop fwupd snapd
apt-get purge -y fwupd snapd
apt-get autoremove -y

# 3. Update system packages
apt-get update -y
apt-get upgrade -y

# 4. Configure journald for persistent logging and size limits
mkdir -p /var/log/journal
sed -i 's/#SystemMaxUse=/SystemMaxUse=200M/' /etc/systemd/journald.conf
sed -i 's/#Storage=auto/Storage=persistent/' /etc/systemd/journald.conf
systemctl restart systemd-journald

# 5. Ensure your bot services are started
# Note: Ensure these unit files are already in your AMI or created above this line.
systemctl enable discord-general
systemctl start discord-general
systemctl enable discord-news
systemctl start discord-news
