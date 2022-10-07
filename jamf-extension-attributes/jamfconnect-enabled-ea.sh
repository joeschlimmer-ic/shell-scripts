#!/bin/bash

if ! security authorizationdb read system.login.console 2>&1 | grep -q 'JamfConnectLogin'; then
    echo "<result>false</result>"
else
    echo "<result>true</result>"
fi
