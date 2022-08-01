#!/bin/bash

#tell openrc loopback and net are already there, since docker handles the networking
echo 'rc_provide="loopback net"' >> /etc/rc.conf

rc-update add keepalived default
rc-update add nginx default
chmod +r /etc/keepalived/keepalived.conf

#nginx -s reload
echo "nginx status:"
# #nginx -s start
rc-service nginx status
rc-service nginx restart
rc-service nginx status
echo "keepalived status: "
#keepalived -l -D
rc-service keepalived status
rc-service keepalived restart
rc-service keepalived status
echo "syslogd status: "
syslogd

mkdir -p /var/log/logrotate
touch /var/log/logrotate/logrotate_operate.log
#run logrotate every 5 minutes to check if log file hasn't growth too big -- for nginx logs only
echo "*/5    *       *       *       *       logrotate -v --log=/var/log/logrotate/logrotate_operate.log /etc/logrotate.d/nginx" >> /etc/crontabs/root
crond -l 2 

bash