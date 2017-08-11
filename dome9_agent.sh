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