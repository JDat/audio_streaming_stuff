#!/bin/bash

## need to set run everey day @ approx 4:00
## add this to crontab
## edit /etc/crontab with nano
#0 4 * * *    root    /absolute/path/to/restart.sched.sh
#! fixme: run witch correct user or with root. Need to think

## or use "sudo crontab -e"
#0 4 * * * /absolute/path/to/restart.sched.sh

## this is example debug to call every minute:
#*/1 * * * *   root   /absolute/path/to/restart.sched.sh


# Hardcoded default config path. This can be edited manualy or by sed
configfile="/home/jdat/aglona/streaming.dev/config.sh"

#This variable must exist or if statment fail
editAndExit=0       # used for hardcodes variable update instead of reboot
# 0 - normal flow (will do reboot)
# 1 - only update hardcoded config variable. no reboot here

# check for command line argument
if [ -n "$1" ]
then
    # We have command line argument
    # So we will not reboot, but update hardcoded config path
    configfile=$1
    editAndExit=1
    #echo "Set mode: edit config and exit"

# No command line.
# Check for config in script folder
elif test -f "${0%/*}/config.sh"
then
    # We have config.sh in script folder
    # Use config.sh from config folder
    configfile=${0%/*}/config.sh
    #echo "Found config.sh in script folder"
    #echo $configfile
fi

# Check for valid config.sh script
# If bad config then DIE!!!
source $configfile
status=$?
if test $status -eq 0
then
    # Cool! We inculded config!
    #echo "Config included sucessfully"
    # Chech for some variables
    if [ -n $restartbase ]
    then
        # Cool! We have valid restart base path
        echo "System configured sucessfully. Going forward."
    else
        # Dohh! We don't have valid restartbasepath. DIE!!!
        #echo "Can't find restartbasepath. Exiting now."
        exit 1        
    fi
else
    # Dohh! We can't inculde config. File not found? DIE!!!
    #echo "Can't include config.sh. File not found? Exiting now."
    exit 1
fi

# If editAndExit then update script with sed and exit
if [ $editAndExit == 1 ]
then
    #echo "Editing hardcoded variable with sed and exit"
    sed -i "0,/.*configfile.*/{s||configfile=\"$1\"|}" ${0}
    exit 0
fi

# Check if script already running
for pid in $(pidof -x ${0##*/}); do
    if [ $pid != $$ ]; then
        #echo "[$(date)] : ${0##*/} : Process is already running with PID $pid"
        #echo "Exiting"
        exit 1
    fi
done

#echo "do reboot work"

# for debug
#exit

if [ ! -w "$restartdebugfile" ]
then
    touch $restartdebugfile
    chown $systemuser:$systemgroup $restartdebugfile
    echo "messing with debug file"
fi


# Remove files
function removeFiles {
    rm $restartabortfile > /dev/null
    rm $restartstatusfile > /dev/null
}
# Trap exit with Ctrl+c or something like this
trap finish EXIT

# start GAMBAS or other GUI program here
while (( $restartimeout > 0 ))
do
    debugprint "restartimeout = $restartimeout" $restartdebugfile
    echo "$restartimeout" > $restartstatusfile
    restartimeout=$(( restartimeout-1 ))
    if test -e $restartabortfile
    then
        removeFiles
        debugprint "Abort restart script: Found $restartabortfile" $restartdebugfile
        exit
    fi
    sleep 1
done

removeFiles
debugprint "exiting (rebooting system)" $restartdebugfile
#sudo reboot now
