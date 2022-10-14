#!/bin/bash
# Check to see if LAPS is installed and sends the version to jamf EA
# Joe Schlimmer
# Last Updated: 2022-10-14

if [ -e "/usr/local/laps/macOSLAPS" ] ; then
    echo "<result>$(/usr/local/laps/macOSLAPS -version)</result>"
elif [ -e "/usr/local/bin/laps/macOSLAPS" ] ; then
    echo "<result>$(/usr/local/bin/laps/macOSLAPS -version)</result>"
else
	echo "<result>Not Installed</result>"
fi