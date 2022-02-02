#!/bin/bash
# Created by Seamus
# Updated by Joe 2022-02-02 (Bugs fix)
#
#Joe Schlimmer — Today at 12:33 PM
# Also I fixed a few bugs with that network filter script 😛
#seamus — Today at 12:33 PM
# 😄
# listen, I am not good at computer
#Joe Schlimmer — Today at 12:34 PM
# I smash my face into computer until behaves
# often takes hours of pain
#seamus — Today at 12:34 PM
# yes, such pain for so little 😛

#this ensures that ATP is set up with enforce mode, but with network-filter disabled
mdatp config cloud --value enabled
mdatp config cloud-diagnostic --value enabled
mdatp threat policy set --type potentially_unwanted_application --action block
mdatp config passive-mode --value disabled
mdatp system-extension network-filter --value disable