#!/bin/bash
# Check to see if LAPS is installed and send the version to jamf EA
# Joe Schlimmer
# Last Updated: 2022-10-14

laps="/usr/local/laps/macOSLAPS"

if [ -e "$laps" ] ; then
    echo "<result>$(/usr/local/laps/macOSLAPS -version)</result>"
else
	echo "<result>Not Installed</result>"
fi