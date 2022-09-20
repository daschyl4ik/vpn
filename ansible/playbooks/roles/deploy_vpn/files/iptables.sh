#!/bin/bash
# Add iptables rules in two scripts
	mkdir -p /etc/iptables
	# Script to add rules
	echo "#!/bin/sh
iptables -t nat -I POSTROUTING 1 -s 10.8.0.0/24 -o ens5 -j MASQUERADE
iptables -I INPUT 1 -i tun0 -j ACCEPT
iptables -I FORWARD 1 -i ens5 -o tun0 -j ACCEPT
iptables -I FORWARD 1 -i tun0 -o ens5 -j ACCEPT
iptables -I INPUT 1 -i ens5 -p udp --dport 1194 -j ACCEPT" >/etc/iptables/add-openvpn-rules.sh
	# Script to remove rules
	echo "#!/bin/sh
iptables -t nat -D POSTROUTING -s 10.8.0.0/24 -o ens5 -j MASQUERADE
iptables -D INPUT -i tun0 -j ACCEPT
iptables -D FORWARD -i ens5 -o tun0 -j ACCEPT
iptables -D FORWARD -i tun0 -o ens5 -j ACCEPT
iptables -D INPUT -i ens5 -p udp --dport 1194 -j ACCEPT" >/etc/iptables/rm-openvpn-rules.sh

	chmod +x /etc/iptables/add-openvpn-rules.sh
	chmod +x /etc/iptables/rm-openvpn-rules.sh
	# Handle the rules via a systemd script
	echo "[Unit]
Description=iptables rules for OpenVPN
Before=network-online.target
Wants=network-online.target
[Service]
Type=oneshot
ExecStart=/etc/iptables/add-openvpn-rules.sh
ExecStop=/etc/iptables/rm-openvpn-rules.sh
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target" >/etc/systemd/system/iptables-openvpn.service
	# Enable service and apply rules
	systemctl daemon-reload
	systemctl enable iptables-openvpn
	systemctl start iptables-openvpn