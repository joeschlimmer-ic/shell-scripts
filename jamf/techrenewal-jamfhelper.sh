#!/bin/bash

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
        echo "$(date)::: Opening Scheduling page" >> /var/log/tech_renewal.log
        echo "Your Ithaca College Mac Serialnumber: $computerSerial" >> /var/log/tech_renewal.log
        open "https://bit.ly/ICTechRenewal"
elif [ "$buttonClicked" == 2 ]; then
	# Buttion 2 was Clicked
        echo "$(date)::: I dont want to right now" >> /var/log/tech_renewal.log
fi
exit $?
