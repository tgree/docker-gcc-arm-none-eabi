#!/usr/bin/env bash

# Exit when any command fails.
set -e

# Remove aliases.txt.
rm -f aliases.txt

# Build each docker container.
pushd versions
for version in gcc-*; do
    echo "***************** Building: $version *****************"
    docker build -t $version $version/
    echo "alias $version='docker run --env LINES=`tput lines` --env COLUMNS=`tput cols` -ti --rm --mount type=bind,source=\"\$(pwd)\",target=/mnt/bind-root $version'" >> ../aliases.txt
done
popd
