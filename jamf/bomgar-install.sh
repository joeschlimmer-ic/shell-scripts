#!/bin/bash

# Setup bomgar on the logged in user's desktop
# Jamf policy, run on a Login trigger, once per user per computer
# Joe Schlimmer - 12-3-2019
###### Changelog #######
# 8-20-2020 
# 1). Changed shell to bash
# 2). Changed sleep 15 line to use a while loop to shorten up the wait period 
# and account for slower connections
# 3). Replaced -a (.app) exists check with -f (any file). I'm pretty sure the check
# was just failing every time and re-downloading bomgar

# UID for the current Bomgar DMG (Bomgar DMGs expire after a specified time, or after each update to the Bomgar server)
# Specififed in Jamf Parameter 4. The Bomgar org UID is included in the name of the downloaded DMG. bomgar-scc-<ohgodallthelettersandnumbersUID>.dmg
bomgaruid="$4"

install_bomgar () {
    # Attach the DMG
    echo "mount the bomgar DMG"
    hdiutil attach /Users/Shared/bomgar-scc-$bomgaruid.dmg

    # Run the installer and wait for install to complete
    echo "Run the installer and wait for completion"
    /Volumes/bomgar-scc/Double-Click\ To\ Start\ Support\ Session.app/Contents/MacOS/sdcust --silent
    sleep 30
}

# Wait until the dock is loaded.
dockStatus=$(pgrep -x Dock)
while [ "$dockStatus" == "" ]; do
    sleep 3
    dockStatus=$(pgrep -x Dock)
done

# Check that the Bomgar DMG us cached prior to running this script
if [[ ! -f "/Users/Shared/bomgar-scc-$bomgaruid.dmg" ]]; then
    echo "Bomgar NOT Present, downloading bomgar"
    /usr/local/bin/jamf policy -event bomgar
    while [[ ! -f "/Users/Shared/bomgar-scc-$bomgaruid.dmg" ]]; do
        sleep 2
    done
fi

install_bomgar

exit $?