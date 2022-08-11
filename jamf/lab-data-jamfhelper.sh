#!/bin/bash
# Joe Schlimmer
# Ithaca College
# 2022-08-11

# Installer Script for data deletion alert script and launchagent on lab macs
# Installs edu.ithaca.datadeletion.plist into /Library/LaunchAgents folder

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
	 edu.ithaca.datadeletion.plist
	 Created by Joseph Schlimmer on 8/11/2022.
	 Copyright (c) 2022 Joseph Schlimmer. All rights reserved.
-->
<plist version="1.0">
	<dict>
		<key>Label</key>
		<string>edu.ithaca.datadeletion</string>
		<key>LimitLoadToSessionType</key>
		<array>
			<string>Aqua</string>
		</array>
		<key>ProgramArguments</key>
		<array>
			<string>/Library/Ithaca/datadeletion.sh</string>
		</array>
		<key>RunAtLoad</key>
		<true/>
        <key>StartInterval</key> 
        <integer>604800</integer>
		<key>StandardOutPath</key>
		<string>/var/tmp/datadeletion.log</string>
		<key>StandardErrorPath</key>
		<string>/var/tmp/datadeletion.log</string>
	</dict>
</plist>
EOF
/bin/echo "$launchAgent" > /Library/LaunchAgents/edu.ithaca.datadeletion.plist

#set ownership and permissions
log "Set plist ownership and permissions"

/usr/sbin/chown root:wheel /Library/LaunchAgents/edu.ithaca.datadeletion.plist
/bin/chmod 644 /Library/LaunchAgents/edu.ithaca.datadeletion.plist

log "Install datadeletion.sh"

IFS= read -r -d '' datadeletion <<"EOF"
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
    -heading "Personal Data warning" \
    -description "Data on this computer is not backed up. This computer may be wiped or repurposed at any time without warning. Please make sure your data is backed up to a cloud service such as OneDrive, or a device like a thumb drive." \
    -button1 "More info" \
    -button2 "I understand")

if [ "$buttonClicked" == 0 ]; then
	# Buttion 1 was Clicked
        echo "$(date)::: Opening data retention info page" >> /var/tmp/tech_renewal.log
        echo "Ithaca College lab Mac Serialnumber: $computerSerial" >> /var/tmp/tech_renewal.log
        open "https://ithaca.edu/it"
elif [ "$buttonClicked" == 2 ]; then
	# Buttion 2 was Clicked
        echo "$(date)::: I, $loggedInuser, understand that my data may be wiped at any time" >> /var/tmp/tech_renewal.log
fi
exit $?
EOF
/bin/echo "$datadeletion" > /Library/Ithaca/datadeletion.sh

/usr/sbin/chown root:wheel /Library/Ithaca/datadeletion.sh
/bin/chmod 755 /Library/Ithaca/datadeletion.sh

log "LaunchAgent and Script install complete"
log "boostrapping the launchagent"

	launchctl bootout gui/"$userID" /Library/LaunchAgents/edu.ithaca.datadeletion.plist
	launchctl bootstrap gui/"$userID" /Library/LaunchAgents/edu.ithaca.datadeletion.plist

exit $?

