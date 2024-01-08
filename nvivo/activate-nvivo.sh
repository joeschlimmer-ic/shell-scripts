#!/bin/bash

# For NVivo
# Deactivate existing license and activate with new license
#
# 2020-8-28: Added more verbose script feedback lines
# 2022-1-26: Revised to support both nvivo 12 and 20 activation
# 2023-1-8: Updated to support NVivo 14
#
# Use in Jamf Pro policy, make sure to set the 4 and 5 parameters
# Version value can be 12 or 20 14
#
# Joe Schlimmer
# Ithaca College

license="$4"
version="$5"

cat > /tmp/license_data.xml << EOF
<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<Activation>
  <Request>
    <FirstName>Ithaca</FirstName>
    <LastName>College</LastName>
    <Email>itslabdeployment@ithaca.edu</Email>
    <Phone></Phone>
    <Fax></Fax>
    <JobTitle></JobTitle>
    <Sector></Sector>
    <Industry></Industry>
    <Role></Role>
    <Department></Department>
    <Organization></Organization>
    <City>Ithaca</City>
    <Country>USA</Country>
    <State>New York</State>
  </Request>
</Activation>
EOF

if [[ "$license" == "" ]]; then
    echo "License not specified"
    exit 1
fi

if [[ "$version" == "" ]]; then
    echo "Version not specified or unknown"
    exit 1
fi

if [[ "$version" == 12 ]]; then
    nvivo="/Applications/NVivo 12.app/Contents/MacOS/NVivo 12"
fi

if [[ "$version" == 14 ]]; then
    nvivo="/Applications/NVivo 14.app/Contents/MacOS/NVivo 14"
fi

if [[ "$version" == 20 ]]; then
    nvivo="/Applications/NVivo.app/Contents/MacOS/NVivo"
fi

echo "Removing any existing Nvivo licenses"
"$nvivo" -deactivate

echo "Activating Nvivo"
"$nvivo" -initialize "$license" -activate /tmp/license_data.xml

exit 0
