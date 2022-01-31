#!/bin/bash
#
# Deactivate existing license and activate with new license
# For Use in a Jamf Pro script policy.
# Make sure to set the 4 and 5 parameters.
#
# license="YOURNVNVIOLICENSECODE"
# version="12" or version="20"
#
# Joe Schlimmer - 1-2-2020
# 8-28-2020: Added more verbose script feedback lines
# 2022-01-26: Revise to support both nvivo 12 and 20 activation
#

license="$4"
version="$5"

cat > /tmp/license_data.xml << EOF
<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<Activation>
  <Request>
    <FirstName>FIRST NAME</FirstName>
    <LastName>LAST NAME</LastName>
    <Email>EMAIL@DOMAIN</Email>
    <Phone></Phone>
    <Fax></Fax>
    <JobTitle></JobTitle>
    <Sector></Sector>
    <Industry></Industry>
    <Role></Role>
    <Department></Department>
    <Organization></Organization>
    <City>CITY</City>
    <Country>NATION</Country>
    <State>STATE</State>
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
