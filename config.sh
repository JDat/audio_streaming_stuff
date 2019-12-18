#!/bin/bash
## global config and utility functions
#[Default]
## *********************************************************************
## this must be set during install

## user and group name for same chown or systemctl commands
systemuser=jdat
systemgroup=jdat

## base path for all scripts
systempath="/home/$systemuser/aglona/streaming"

## end of install dependend variables
## *********************************************************************


## restart base path
restartbase=$systempath
## restart timeout in seconds normally 600 seconds (10 minutes)
restartimeout=300

restartdebugfile="$restartbase/restart.debug.txt"
#restartdebugfile=/dev/null
restartabortfile="$restartbase/abortrestart.txt"
restartstatusfile="$restartbase/restartdata.txt"

## icecast server checking
checkicecasttimeout=1

checkicecastbase=$systempath
checkicecastdebugfile="$checkicecastbase/checkicecast.debug.txt"
checkicecastlogfile="$checkicecastbase/checkicecast.log.txt"
urlstring="http://a.radiolg.lv:8000"
mainstream="/aglona.ogg"
kriptsstream="/aglona.kripts.ogg"
backupstream="/aglona.bkp.ogg"

## ping gateway

pinggatewaysleeptime=5

pinggatewaybase=$systempath
pinggatewaydebugfile="$pinggatewaybase/ping.gateway.debug.txt"
pinggatewaylogfile="$pinggatewaybase/ping.gateway.log.txt"

source util.sh
