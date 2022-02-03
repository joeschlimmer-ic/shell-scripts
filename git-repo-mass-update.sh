#!/bin/bash

path="$1"

if [[ ! -z "$path" ]]; then
    pushd "$(pwd)"
    cd "$path"
    for item in *; do
        if [[ -d "$item" ]]; then
            cd $item
            pwd
            if [[ -d .git ]]; then
                git pull
            fi
            cd ..
        else
            continue
        fi
    done
    popd
else
    echo "Must specifiy a parent directory to operate on. (., dirname)"
fi

exit $?
