#!/bin/sh

trails=(
interloken
no-tan-takto
backbone
flt-nct
ravine
gorge
burnt-hill
southslope 	
potomac
chicken-coop
)

for trail in ${trails[@]}; do
    touch "$trail.html"
    echo "Created $trail.html"
done

