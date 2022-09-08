#!/bin/bash
# Detect auditbeat install status and version
# Joe Schlimmer
# Created: 2022-09-08
# Last updated: 2022-09-08

if [[ -f /Applications/auditbeat/auditbeat ]] ; then
    version=$(/Applications/auditbeat/auditbeat version | awk '{print $3}')
    echo "<result>$version</result>"
else
    echo "<result>Not installed</result>"
fi

exit 0
