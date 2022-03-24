#!/bin/bash

log() {
    echo "$1"
    /usr/bin/logger -t "NoMAD Installer:" "$1"
}
log "Installing NoMAD.app"

tempDir=$(/usr/bin/mktemp -d -t "NoMAD_Installer")

cleanUp() {
    log "Performing cleanup tasks..."
    /bin/rm -r "$tempDir"
}

trap cleanUp exit

loggedInUser=$( scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }' )
loggedInUserPid=$(id -u "$loggedInUser")
log "Current user and PID: $loggedInUser / $loggedInUserPid"


packageDownloadUrl="https://files.nomad.menu/NoMAD.pkg"

log "Downloading NoMAD.pkg..."
if ! /usr/bin/curl -s "$packageDownloadUrl" -o "$tempDir/NoMAD.pkg" ; then
    log "curl error: The package did not successfully download"; exit 1
fi

if ! /usr/sbin/pkgutil --check-signature "$tempDir/NoMAD.pkg" ; then
    log "pkgutil error: The downloaded package did not pass the signature check"; exit 1
fi

log "Installing NoMAD.app..."
if ! /usr/sbin/installer -pkg "$tempDir/NoMAD.pkg" -target / ; then
    log "installer error: The package did not successfully install"; exit 1
fi

log "Writing LaunchAgent..."
IFS= read -r -d '' launchAgent <<"EOF"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>com.trusourcelabs.NoMAD</string>
        <key>LimitLoadToSessionType</key>
        <array>
        <string>Aqua</string>
        </array>
        <key>ProgramArguments</key>
        <array>
        <string>/Applications/NoMAD.app/Contents/MacOS/NoMAD</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
    </dict>
</plist>
EOF
/bin/echo "$launchAgent" > /Library/LaunchAgents/com.trusourcelabs.NoMAD.plist

/usr/sbin/chown root:wheel /Library/LaunchAgents/com.trusourcelabs.NoMAD.plist
/bin/chmod 644 /Library/LaunchAgents/com.trusourcelabs.NoMAD.plist


if [[ -f /Library/LaunchAgents/com.trusourcelabs.NoMAD.plist ]]; then
    log "Unloading existing LaunchAgent..."
    /bin/launchctl bootout gui/"$loggedInUserPid" /Library/LaunchAgents/com.trusourcelabs.NoMAD.plist
    log "Loading new LaunchAgent..."
    if ! /bin/launchctl bootstrap gui/"$loggedInUserPid" /Library/LaunchAgents/com.trusourcelabs.NoMAD.plist ; then
        log "launchctl error: The LaunchAgent failed to load"; exit 1
    fi
fi

log "NoMAD.app install complete"
exit 0
