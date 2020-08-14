#!/bin/bash

## include timestamps and append data to log file 
## $1 data
## $2 filename

# to debug file
debugprint(){
	timenow=$( date +"%s: %F_%T.%N:" )
	echo "$timenow $1" >> $2
}

# to regular logfile
logprint(){
	timenow=$( date +"%s: %F_%T.%N:" )
	echo "$timenow $1" >> $2
}
