#!/bin/bash

source config.sh

#debugfile=/dev/null
debugfile=$pinggatewaydebugfile

for (( ; ; ))
do
	IP=$(/sbin/ip route | awk '/default/ { print $3 }')
	IP=$(echo $IP | awk '{ print $1 }')
	#echo $IP
	
	pingresult=$(ping -4 -c 1 -W 1 -q $IP &>/dev/null)
	rc=$?
	if [ "$rc" -gt 0 ]; then
		logprint "ping error: $rc" $pinggatewaylogfile
		debugprint "ping error: $rc" $debugfile
	fi
	
	debugprint "ping IP address: $IP \t result: $pingresult" $debugfile
	sleep $pinggatewaysleeptime
done
