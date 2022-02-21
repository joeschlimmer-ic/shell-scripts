#!/bin/bash

# This sets the variable for jamfHelper results from which button was clicked

buttonClicked=$("/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper" \
    -windowType utility -icon "/Library/Ithaca/IC-Logo2L.png" -title "Ithaca College Information Technology" \
    -heading "Ithaca College Tech Renewal Alert" -description "Ithaca College Tech Renewal Alert" \
    -button1 "Ok" -button2 "Cancel")

if [ $buttonClicked == 0 ]; then
	# Buttion 1 was Clicked
	echo "OK"
        open "https://bit.ly/IthacaCollegeSpring22"
elif [ $buttonClicked == 2 ]; then
	# Buttion 2 was Clicked
	echo "Cancel"
fi
