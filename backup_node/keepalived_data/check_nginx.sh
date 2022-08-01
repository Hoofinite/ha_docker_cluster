#!/bin/bash
A=`ps nginx | wc -l`
if [ $A -eq 0 ];then
  rc-service nginx restart
  sleep 2
  if [ `ps nginx | wc -l` -eq 0 ];then
    killall keepalived
  fi
fi