#!/bin/bash

# Joe Schlimmer 2022-03-02

OS_MAJOR=$(/usr/bin/sw_vers -productVersion | /usr/bin/cut -d . -f 1)
OS_MINOR=$(/usr/bin/sw_vers -productVersion | /usr/bin/cut -d . -f 2)
if (( $OS_MAJOR == 10 )) && (( $OS_MINOR < 5 )); then
  if [[ -f /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Support/networksetup ]];then
    echo "$(/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Support/networksetup -listnetworkserviceorder 2>&1 | grep $(/usr/sbin/netstat -rn 2>&1 | /usr/bin/grep -m 1 'default' | /usr/bin/awk '{ print $4 }') | sed -e "s/.*Port: //g" -e "s/,.*//g")"
  else
    echo "The networksetup binary is not present on this machine."
  fi
else
  echo "$(/usr/sbin/networksetup -listnetworkserviceorder 2>&1 | grep $(/usr/sbin/netstat -rn 2>&1 | /usr/bin/grep -m 1 'default' | /usr/bin/awk '{ print $4 }') | sed -e "s/.*Port: //g" -e "s/,.*//g")"
fi

exit $?
