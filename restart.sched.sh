#!/bin/bash
[default]
## add this to crontab
## sudo crontab -e
## need to set run verey day @ approx 4:00
#0 4 * * * /home/user/streaming/restart.sched.sh
## this is example debug to call every minute:
#*/1 * * * * /home/user/streaming/restart.sched.sh

#global config
source config.sh

#chown $systemuser:$systemgroup $restartdebugfile
echo > $restartdebugfile
#chown $systemuser:$systemgroup $restartdebugfile
echo > $restartdebugfile

#start GAMBAS GUI
while (( $restartimeout > 0 ))
do
	debugprint "restartimeout = $restartimeout" $restartdebugfile
	echo "$restartimeout" > $restartstatusfile
	restartimeout=$(( restartimeout-1 ))
	if test -e $restartabortfile
	then
		rm $restartstatusfile > /dev/null
		rm $restartabortfile > /dev/null
		debugprint "Abort restart script: Found $restartabortfile" $restartdebugfile
		exit
	fi
	sleep 1
done

rm $restartabortfile > /dev/null
rm $restartstatusfile > /dev/null
debugprint "exiting (rebooting system)" $restartdebugfile
#sudo reboot now
