#!/bin/bash
# 1. Update system packages (security & stability).
apt-get update -y
apt-get upgrade -y

# 2. Configure journald for persistent logging and size limits.
mkdir -p /var/log/journal
sed -i 's/#SystemMaxUse=/SystemMaxUse=200M/' /etc/systemd/journald.conf
sed -i 's/#Storage=auto/Storage=persistent/' /etc/systemd/journald.conf

# 3. Apply the journald changes.
systemctl restart systemd-journald

# 4. Ensure your bot services are started (optional safety net).
systemctl enable discord-general
systemctl start discord-general
systemctl enable discord-news
systemctl start discord-news
