#!/bin/bash

# deactivate existing license and activate with new license
# Joe Schlimmer Ithaca College 1-2-2020
# 8-28-2020: Added more verbose script feedback lines
# 2022-01-26: Revise to support both nvivo 12 and 20 activation
# Use in Jamf Pro policy, make sure to set the 4 and 5 parameters
# Version value can be 12 or 20
# Fill in FirstName, LastName, Email, City, Country, State fields in XML activation template

license="$4"
version="$5"

cat > /tmp/license_data.xml << EOF
<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<Activation>
  <Request>
    <FirstName></FirstName>
    <LastName></LastName>
    <Email></Email>
    <Phone></Phone>
    <Fax></Fax>
    <JobTitle></JobTitle>
    <Sector></Sector>
    <Industry></Industry>
    <Role></Role>
    <Department></Department>
    <Organization></Organization>
    <City></City>
    <Country></Country>
    <State></State>
  </Request>
</Activation>
EOF

if [[ "$version" == 12 ]]; then
    nvivo="/Applications/NVivo 12.app/Contents/MacOS/NVivo 12"
elif [[ "$version" == 20 ]]; then
    nvivo="/Applications/NVivo.app/Contents/MacOS/NVivo"
else
    echo "Version not specified or unknown"
    exit 1
fi


echo "Removing any existing Nvivo licenses"
"$nvivo" -deactivate

echo "Activating Nvivo"
"$nvivo" -initialize "$license" -activate /tmp/license_data.xml

exit 0
