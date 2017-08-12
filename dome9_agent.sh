# for debian ...
# req:  python > 2.4 < 3.0 :(
#       openssl
#       iptables
wget http://repository.dome9.com/dist/Dome9Agent-latest.tar.gz
tar xvfz Dome9Agent-latest.tar.gz && cd Dome9Agent-latest.tar.gz
sudo python setup.py install
sudo cp contrib/dome9d_init /etc/init.d/dome9d
sudo cp contrib/dome9d_cron /etc/cron.d/dome9d
sudo chown root:root /etc/init.d/dome9d
sudo chmod +x /etc/init.d/dome9d
sudo update-rc.d dome9d defaults
dome9d pair -k <pairing key> -s <servername>
sudo update-rc.d dome9d enable

# openvpn settings for dome9
sudo echo 'net.ipv4.ip_forward=1' | sudo tee -a /etc/sysctl.d/99-sysctl.conf
echo 1 > /proc/sys/net/ipv6/conf/all/forwarding
sudo sysctl -p
sudo iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A FORWARD -i tun0 -o eth0 -s 10.8.0.0/24 -j ACCEPT
sudo echo -e "# forwarding\n-I FORWARD -j ACCEPT" >> /usr/share/pyshared/dome9/agent/iptables.boilerplate