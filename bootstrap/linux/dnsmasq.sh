#http://askubuntu.com/questions/233195/route-complete-tld-dev-for-example-to-127-0-0-1/233224#233224
#Create the directory mkdir /etc/NetworkManager/dnsmasq.d if it doesn't already exist.

#sudo mkdir /etc/NetworkManager/dnsmasq.d
#Toss the following line into /etc/NetworkManager/dnsmasq.d/dev-tld.

#address=/dev/127.0.0.1
#Restart NetworkManager.

#sudo service network-manager restart
