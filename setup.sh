#!/bin/bash


RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e "This scripts:
  ${YELLOW}*${NC} Auto configure ${GREEN}Raspberry Pi Model 3${NC} as wifi router with Tor proxy.
  ${YELLOW}*${NC} Recommend : Run this script on ${GREEN}fresh installation of Raspbian${NC}.
  ${YELLOW}*${NC} The name of ethernet interface must be ${GREEN}eth0${NC}.
  ${YELLOW}*${NC} The name of wifi interface must be ${GREEN}wlan0${NC}."


if [ `whoami` != "root" ]; then
    echo -e "This script must be run as ${RED}root${NC}."
    echo -e "Please type in ${GREEN}sudo !!${NC} to run as root."
    exit 1
fi

echo -e "${GREEN}Updating...${NC}"
read -p "Press [y/n] to continue..." ans
if [ $ans == "y" ];then
    apt-get update -y
fi
echo -e "${GREEN}Upgarding...${NC}"
read -p "Press [y/n] to continue..." ans
if [ $ans == "y" ];then
    apt-get upgarde -y
fi

echo "Installing various packages..."
apt-get install -y tor hostapd isc-dhcp-server iptables-persistent


sed -e '/option domain-name "example.org";/ s/^#*/#/' -i /etc/dhcp/dhcpd.conf
sed -e '/option domain-name-servers ns1.example.org, ns2.example.org;/ s/^#*/#/' -i /etc/dhcp/dhcpd.conf
sed '/^#authoritative;/s/^#//' -i /etc/dhcp/dhcpd.conf

cat dhcp.config >> /etc/dhcp/dhcpd.conf

echo 'INTERFACESv4="wlan0"' > /etc/default/isc-dhcp-server
rm /var/run/dhcpd.pid
service isc-dhcp-server stop
service isc-dhcp-server start

#Assigning the static IP to the wlan interface
ifconfig wlan0 down
cat interfaces.config > /etc/networks/interfaces
ifconfig wlan0 up


cat hostapd.config > /etc/hostapd/hostapd.conf
sed 'DAEMON_CONF="/etc/hostapd/hostapd.conf"' > /etc/default/hostapd

echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

cat tor.config > /etc/tor/torrc
iptables -F
iptables -t nat -F
iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 22 -j REDIRECT --to-ports 22
iptables -t nat -A PREROUTING -i wlan0 -p udp --dport 53 -j REDIRECT --to-ports 53
iptables -t nat -A PREROUTING -i wlan0 -p tcp --syn -j REDIRECT --to-ports 9040
iptables -t nat -L
iptables-save > /etc/iptables/rules.v4

cat >> /etc/rc.local << EOF
iptables-restore < /etc/iptables.conf
EOF


touch /var/log/tor/notices.log
chown debian-tor /var/log/tor/notices.log
chmod 644 /var/log/tor/notices.log
service tor start
update-rc.d tor enable
