# Clear all old rules
# Flush
sudo iptables -F
sudo iptables -F -t mangle
sudo iptables -F -t nat

# Delete chain
sudo iptables -X
sudo iptables -X -t mangle
sudo iptables -X -t nat

# Set default policies for each chain
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT DROP

# Accept local traffic
sudo iptables -A INPUT -i lo -j ACCEPT

# SSH incoming OK: stateful
sudo iptables -A INPUT -i eth0 -p tcp --dport 22 -m conntrack --ctstate NEW, ESTABLISHED -j ACCEPT

# Accept packets from trusted IP addresses
sudo iptables -A INPUT -s 192.168.0.4 -j ACCEPT

# Allow all incoming HTTPS connections
sudo iptables -A INPUT -p tcp --dport 443 -m conntrack --ctstate NEW, ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 443 -m conntrack --ctstate ESTABLISHED -j ACCEPT

# Default catch-all
sudo iptables -A INPUT -j REJECT

# Output
sudo iptables -A OUTPUT -o lo -j ACCEPT

# Output SSH allowed
sudo iptables -A OUTPUT -o eth0 -p tcp --sport 22 -m conntrack --ctstate ESTABLISHED -j ACCEPT

# Default catch-all
sudo iptables -A OUTPUT -j REJECT

# save iptables rule
sudo bash -c "iptables-save > /etc/iptables.up.rules"

# store variable reload that reloads the config
reload="pre-up iptables-restore < /etc/iptables.up.rules"

# defines at startup
sudo bash -c "echo '$reload' >> /etc/network/interfaces"

echo | sudo iptables -L -v
echo | sudo iptables -S

