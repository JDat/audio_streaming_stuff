#!/bin/bash

source config.sh

debugfile=/dev/null
#debugfile=$checkicecastdebugfile

for (( ; ; ))
do
    html=$( curl -s "$urlstring" )
    rc=$?
    if [ "$rc" -gt 0 ]; then
        logprint "curl error: $rc" $checkicecastlogfile
    else

        if grep -q "$mainstream" <<< "$html"; then
            debugprint "Found $mainstream" $debugfile
        else
            logprint "Not found: $mainstream" $checkicecastlogfile
        fi

        if grep -q "$kriptsstream" <<< "$html"; then
            debugprint "Found $kriptsstream" $debugfile
        else
            logprint "Not found: $kriptsstream" $checkicecastlogfile
        fi

        if grep -q "$backupstream" <<< "$html"; then
            debugprint "Found $backupstream" $debugfile
        else
            logprint "Not found: $baskupstream" $checkicecastlogfile
        fi
    fi

    sleep $checkicecasttimeout
done
