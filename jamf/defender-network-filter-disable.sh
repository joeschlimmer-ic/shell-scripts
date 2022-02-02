#!/bin/bash

#this ensures that Microsoft Defender is set up with enforce mode, but with network-filter disabled
mdatp config cloud --value enabled
mdatp config cloud-diagnostic --value enabled
mdatp threat policy set --type potentially_unwanted_application --action block
mdatp config passive-mode --value disabled
mdatp system-extension network-filter --value disable