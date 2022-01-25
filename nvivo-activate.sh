#!/bin/bash

# deactivate existing license and activate with new license
# Joe Schlimmer Ithaca College 1-2-2020
# 8-28-2020: Added more verbose script feedback lines

license="$4"

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

echo "Removing any existing Nvivo licenses"
"/Applications/NVivo 12.app/Contents/MacOS/NVivo 12" -deactivate

echo "Activating Nvivo 12"
"/Applications/NVivo 12.app/Contents/MacOS/NVivo 12" -initialize "$license" -activate /tmp/license_data.xml