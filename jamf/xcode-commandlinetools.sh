#!/bin/bash

# Installing the Xcode command line tools on 10.7.x or higher

# Save current IFS state

OLDIFS=$IFS

IFS='.' read osvers_major osvers_minor osvers_dot_version <<< "$(/usr/bin/sw_vers -productVersion)"

# restore IFS to previous state

IFS=$OLDIFS

cmd_line_tools_temp_file="/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress"

# Installing the latest Xcode command line tools on 10.9.x or higher

if [[ ( ${osvers_major} -eq 10 && ${osvers_minor} -ge 9 ) || ( ${osvers_major} -ge 11 && ${osvers_minor} -ge 0 ) ]]; then

	# Create the placeholder file which is checked by the softwareupdate tool 
	# before allowing the installation of the Xcode command line tools.
	
	touch "$cmd_line_tools_temp_file"
	
	# Identify the correct update in the Software Update feed with "Command Line Tools" in the name for the OS version in question.

	if [[ ( ${osvers_major} -eq 10 && ${osvers_minor} -ge 15 ) || ( ${osvers_major} -ge 11 && ${osvers_minor} -ge 0 ) ]]; then
	   cmd_line_tools=$(softwareupdate -l | awk '/\*\ Label: Command Line Tools/ { $1=$1;print }' | sed 's/^[[ \t]]*//;s/[[ \t]]*$//;s/*//' | cut -c 9-)	
	elif [[ ( ${osvers_major} -eq 10 && ${osvers_minor} -gt 9 ) ]] && [[ ( ${osvers_major} -eq 10 && ${osvers_minor} -lt 15 ) ]]; then
	   cmd_line_tools=$(softwareupdate -l | awk '/\*\ Command Line Tools/ { $1=$1;print }' | grep "$macos_vers" | sed 's/^[[ \t]]*//;s/[[ \t]]*$//;s/*//' | cut -c 2-)
	elif [[ ( ${osvers_major} -eq 10 && ${osvers_minor} -eq 9 ) ]]; then
	   cmd_line_tools=$(softwareupdate -l | awk '/\*\ Command Line Tools/ { $1=$1;print }' | grep "Mavericks" | sed 's/^[[ \t]]*//;s/[[ \t]]*$//;s/*//' | cut -c 2-)
	fi
	
	# Check to see if the softwareupdate tool has returned more than one Xcode
	# command line tool installation option. If it has, use the last one listed
	# as that should be the latest Xcode command line tool installer.
	
	if (( $(grep -c . <<<"$cmd_line_tools") > 1 )); then
	   cmd_line_tools_output="$cmd_line_tools"
	   cmd_line_tools=$(printf "$cmd_line_tools_output" | tail -1)
	fi
	
	#Install the command line tools
	
	softwareupdate -i "$cmd_line_tools" --verbose
	
	# Remove the temp file
	
	if [[ -f "$cmd_line_tools_temp_file" ]]; then
	  rm "$cmd_line_tools_temp_file"
	fi
fi

exit 0
