#!/bin/bash
# Updated from Jamf Cloud template for active network interface
# Change awk print colume from 6 to 4
# Add OS_MAJOR version check to deal with big sur and newer
# Joe Schlimmer 2022-01-31

OS_MAJOR=$(/usr/bin/sw_vers -productVersion | /usr/bin/cut -d . -f 1)
OS_MINOR=$(/usr/bin/sw_vers -productVersion | /usr/bin/cut -d . -f 2)
if (( $OS_MAJOR == 10 )) && (( $OS_MINOR < 5 )); then
  if [[ -f /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Support/networksetup ]];then
    echo "<result>$(/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Support/networksetup -listnetworkserviceorder 2>&1 | grep $(/usr/sbin/netstat -rn 2>&1 | /usr/bin/grep -m 1 'default' | /usr/bin/awk '{ print $4 }') | sed -e "s/.*Port: //g" -e "s/,.*//g")</result>"
  else
    echo "<result>The networksetup binary is not present on this machine.</result>"
  fi
else
  echo "<result>$(/usr/sbin/networksetup -listnetworkserviceorder 2>&1 | grep $(/usr/sbin/netstat -rn 2>&1 | /usr/bin/grep -m 1 'default' | /usr/bin/awk '{ print $4 }') | sed -e "s/.*Port: //g" -e "s/,.*//g")</result>"
fi
