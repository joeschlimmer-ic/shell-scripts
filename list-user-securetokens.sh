#!/bin/bash

pushd /Users
for user in *; do
    sysadminctl -secureTokenStatus "$user"
done
popd
