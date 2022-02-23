#!/bin/bash

# Installer Script for Tech Renewal alert script and launchagent
# Installs edu.ithaca.techrenewal.plist into /Library/LaunchAgents folder
log() {
    /bin/echo "$1"
    /usr/bin/logger -t "Tech Renewal launchagent and script installer:" "$1"
}

# Make sure the script is run as root
if [[ "$EUID" -ne 0 ]]; then
    log "Please run as root" 
    exit 1
fi

loggedInUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ && ! /loginwindow/ { print $3 }' )
userID=$( id -u "$loggedInUser" )


log "Installing Launchagent"

IFS= read -r -d '' launchAgent <<"EOF"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<!--
	 edu.ithaca.techrenewal.plist
	 Created by Joseph Schlimmer on 2/3/2022.
	 Copyright (c) 2020 Joseph Schlimmer. All rights reserved.
-->
<plist version="1.0">
	<dict>
		<key>Label</key>
		<string>edu.ithaca.techrenewal</string>
		<key>LimitLoadToSessionType</key>
		<array>
			<string>Aqua</string>
		</array>
		<key>ProgramArguments</key>
		<array>
			<string>/Library/Ithaca/techrenewal.sh</string>
		</array>
		<key>RunAtLoad</key>
		<true/>
        <key>StartInterval</key> 
        <integer>604800</integer>
		<key>StandardOutPath</key>
		<string>/var/tmp/tech_renewal.log</string>
		<key>StandardErrorPath</key>
		<string>/var/tmp/tech_renewal.log</string>
	</dict>
</plist>
EOF
/bin/echo "$launchAgent" > /Library/LaunchAgents/edu.ithaca.techrenewal.plist

#set ownership and permissions
log "Set plist ownership and permissions"

/usr/sbin/chown root:wheel /Library/LaunchAgents/edu.ithaca.techrenewal.plist
/bin/chmod 644 /Library/LaunchAgents/edu.ithaca.techrenewal.plist

log "Install techrenewal.sh"

IFS= read -r -d '' techrenewal <<"EOF"
#!/bin/bash
# Display a notification to the end user to schedule a tech renewal appointment
# Joe Schlimmer

loggedInUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ && ! /loginwindow/ { print $3 }' )
computerSerial="$(ioreg -c IOPlatformExpertDevice -d 2 | awk -F\" '/IOPlatformSerialNumber/{print $(NF-1)}')"

# This sets the variable for jamfHelper results from which button was clicked
buttonClicked=$("/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper" \
    -windowType utility \
    -icon "/Library/Ithaca/IC-Logo2L.png" \
    -title "Ithaca College Information Technology" \
    -heading "This computer $computerSerial is scheduled for Technology Renewal" \
    -description "Please schedule the renewal or contact the Ithaca College Service Desk at 607-274-1000" \
    -button1 "OK" \
    -button2 "Cancel")

if [ "$buttonClicked" == 0 ]; then
	# Buttion 1 was Clicked
        echo "$(date)::: Opening Scheduling page" >> /var/tmp/tech_renewal.log
        echo "Your Ithaca College Mac Serialnumber: $computerSerial" >> /var/tmp/tech_renewal.log
        open "https://bit.ly/ICTechRenewal"
elif [ "$buttonClicked" == 2 ]; then
	# Buttion 2 was Clicked
        echo "$(date)::: I dont want to right now" >> /var/tmp/tech_renewal.log
fi
exit $?
EOF
/bin/echo "$techrenewal" > /Library/Ithaca/techrenewal.sh

/usr/sbin/chown root:wheel /Library/Ithaca/techrenewal.sh
/bin/chmod 755 /Library/Ithaca/techrenewal.sh

log "LaunchAgent and Script install complete"
log "boostrapping the launchagent"

	launchctl bootout gui/"$userID" /Library/LaunchAgents/edu.ithaca.techrenewal.plist
	launchctl bootstrap gui/"$userID" /Library/LaunchAgents/edu.ithaca.techrenewal.plist

exit $?
