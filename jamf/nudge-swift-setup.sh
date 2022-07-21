#!/usr/bin/env bash

: <<-LICENSE_BLOCK
nudge-swift-setup (20220721) - Copyright (c) 2021 Joe Schlimmer (https://github.com/wartz)
Licensed under the MIT License
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
LICENSE_BLOCK

# Installs the nudge LaunchAgent and runs an initial check for updates
# Joe Schlimmer
# 2022-07-21

log() {
    echo "$1"
    /usr/bin/logger -t "Nudge LaunchAgent configuration:" "$1"
}
log "Installing Nudge LaunchAgent"

loggedInUser=$( scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }' )
loggedInUserPid=$(id -u "$loggedInUser")
log "Current user and PID: $loggedInUser / $loggedInUserPid"

log "Writing Nudge LaunchAgent..."
IFS= read -r -d '' launchAgent <<"EOF"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>com.github.macadmins.Nudge</string>
	<key>LimitLoadToSessionType</key>
	<array>
		<string>Aqua</string>
	</array>
	<key>ProgramArguments</key>
	<array>
		<string>/Applications/Utilities/Nudge.app/Contents/MacOS/Nudge</string>
	</array>
	<key>RunAtLoad</key>
	<true/>
	<key>StartCalendarInterval</key>
	<array>
		<dict>
			<key>Minute</key>
			<integer>0</integer>
		</dict>
		<dict>
			<key>Minute</key>
			<integer>30</integer>
		</dict>
	</array>
</dict>
</plist>
EOF
echo "$launchAgent" > /Library/LaunchAgents/com.github.macadmins.Nudge.plist

/usr/sbin/chown root:wheel /Library/LaunchAgents/com.github.macadmins.Nudge.plist
/bin/chmod 644 /Library/LaunchAgents/com.github.macadmins.Nudge.plist

log "Loading Nudge LaunchAgent..."

if [[ -f /Library/LaunchAgents/com.github.macadmins.Nudge.plist ]]; then
    log "Unloading existing LaunchAgent..."
    /bin/launchctl bootout gui/"$loggedInUserPid" /Library/LaunchAgents/com.github.macadmins.Nudge.plist
    log "Loading new LaunchAgent..."
    if ! /bin/launchctl bootstrap gui/"$loggedInUserPid" /Library/LaunchAgents/com.github.macadmins.Nudge.plist ; then
        log "launchctl error: The LaunchAgent failed to load"; exit 1
    fi
fi

log "Nudge launchagent install complete"
exit 0
