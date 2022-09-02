#!/bin/bash

# This installs a cached autodesk dmg from /Users/Shared

# Use jamf parameters to fill this in
# Example /Users/Shared/Autodesk_AutoCAD_2023.1_macOS.dmg
dmgpath="$4"
version="$5"

# Remove existing installs
/Applications/Autodesk/AutoCAD\ "$version"/Remove\ AutoCAD\ "$version".app/Contents/MacOS/Remove\ AutoCAD\ "$version" -silent

/usr/bin/hdiutil attach -nobrowse "$dmgpath"
/Volumes/Installer/Install\ Autodesk\ AutoCAD\ "$version"\ for\ Mac.app/Contents/Helper/Setup.app/Contents/MacOS/Setup --silent

/Library/Application\ Support/Autodesk/AdskLicensing/Current/helper/AdskLicensingInstHelper register --pk "777O1" --pv "$version.0.0.F" --lm STANDALONE --sn "302-19297847" --cf /Library/Application\ Support/Autodesk/Adlm/.config/ProductInformation.Pit -el US
