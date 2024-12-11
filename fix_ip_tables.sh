#!/bin/bash

# Ensure root privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root!"
    exit 1
fi

# Define a temporary iptables rules file
RULES_FILE="/tmp/iptables_rules"

# Backup current iptables rules
iptables-save > /tmp/iptables_backup_$(date +%F_%T)

sudo iptables -F      # Flush all rules in all chains
sudo iptables -X      # Delete all user-defined chains
sudo iptables -Z      # Zero packet and byte counters

# Create a new ruleset
cat <<EOF > $RULES_FILE
*filter

# Default policies
:INPUT DROP [0:0]
:FORWARD DROP [0:0]
:OUTPUT ACCEPT [0:0]

# Allow established connections and related traffic
-A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
-A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Allow incoming SSH connections on port 34678
-A INPUT -p tcp --dport 34678 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

# Allow DNS (optional for outbound queries)
-A OUTPUT -p udp --dport 53 -j ACCEPT

# Allow HTTP/HTTPS for updates (optional)
-A OUTPUT -p tcp --dport 80 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
-A OUTPUT -p tcp --dport 443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

# Log dropped traffic
-A INPUT -m limit --limit 5/min --limit-burst 5 -j LOG --log-prefix "IPTables-Dropped: " --log-level 4

# Explicitly drop all other INPUT traffic
-A INPUT -j DROP

COMMIT
EOF

# Apply the rules atomically
iptables-restore < $RULES_FILE

# Test SSH connectivity for 30 seconds before confirming
echo "Testing SSH connectivity. Rules will be confirmed in 30 seconds..."
sleep 30

# Check SSH connectivity
if nc -z localhost 34678; then
    echo "SSH connection is stable. Rules applied successfully!"
else
    echo "SSH connection failed! Restoring previous rules..."
    iptables-restore < /tmp/iptables_backup_$(date +%F_%T)
    exit 1
fi

# Clean up
rm -f $RULES_FILE
echo "Secure iptables rules have been applied and confirmed."


sudo iptables -L -v -n

