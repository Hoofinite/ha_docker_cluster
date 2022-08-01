FROM alpine

#install updates & necessary things
RUN apk add nginx keepalived openrc bash  tzdata logrotate\
    autoconf automake iptables-dev ipset-dev libnfnetlink-dev libnl3-dev musl-dev openssl-dev curl

RUN mkdir -p /run/openrc \
    touch /run/openrc/softlevel

USER root

#copy index to distinguish nodes
COPY /nginx/index.html /usr/share/nginx/html/

RUN openrc

#paste in new KEEPALIVED config
COPY /keepalived_data/keepalived.conf /etc/keepalived/keepalived.conf

#paste in needed check_nginx script
COPY /keepalived_data/check_nginx.sh /usr/local/src/nginx_check.sh
RUN chmod +x /usr/local/src/nginx_check.sh

#for log's clearance lets save default date and time
RUN cp /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
RUN apk del tzdata

#paste default nginx conf
COPY ./nginx/default.conf /etc/nginx/http.d/default.conf

#add some logs of CONF.D keepalived by adding starting parameter to KEEPALIVED_OPTS
COPY /keepalived_data/keepalived /etc/conf.d/keepalived

#KEEPALIVED & nginx script
COPY ./script.sh /script.sh
RUN chmod +x /script.sh

#syslog config for logs retrieving
COPY ./syslogd/syslog.conf /etc/syslog.conf

#logrotate for logs 
COPY ./logrotate_conf/nginx.conf /etc/logrotate.d/nginx
RUN chmod 644 /etc/logrotate.d/nginx



RUN mkdir -p /run/nginx

HEALTHCHECK --interval=5s --timeout=10s --start-period=10s --retries=3 CMD curl -f http://localhost || exit 1

ENTRYPOINT [ "./script.sh" ]