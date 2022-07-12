#!/bin/bash
# Extension attributte for Jamf Pro to detect if Rosetta 2 is installed properly
# Joe Schlimmer
# 2022-07-12

if [[ "$(/usr/bin/arch)" == "arm64"* ]] ; then
    if /usr/bin/pgrep oahd >/dev/null 2>&1 ; then
        echo "<result>installed</result>"
    else
        echo "<result>not</result>"
    fi
else
    echo "<result>intel arch</result>"
fi

exit 0
