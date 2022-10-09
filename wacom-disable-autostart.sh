#!/bin/bash

WCplistFile="/Users/eclassoom/Library/Group Containers/EG27766DY7.com.wacom.WacomTabletDriver/Library/Preferences/com.wacom.wacomtablet.prefs"

/usr/libexec/PlistBuddy -c "set :'WDCAutoStart' false" "${WCplistFile}"

