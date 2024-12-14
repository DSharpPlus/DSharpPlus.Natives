#!/bin/bash

mkdir -p "$WORKSPACE/libs/libzstd"
cd "$WORKSPACE/libs/libzstd"

# clone the repository
git clone https://github.com/facebook/zstd.git .
git fetch --tags

# export the latest tag
LIBZSTD_VERSION="$(git describe --tags $(git rev-list --tags --max-count=1))"
echo "version=$(echo $LIBZSTD_VERSION | perl -pe '($_)=/([0-9]+([.][0-9]+)+)/').$GITHUB_RUN_NUMBER" >> $GITHUB_OUTPUT

# Checkout the latest tag
#  git checkout "$LIBZSTD_VERSION"

# set the working directory to `lib`, where the makefile we want is located
cd "lib"

# automatically exit if the build fails
set -e

# build the library
$COMMAND

# move the output file to the correct location
mkdir -p          "$EXPORT_DIR"
rm -f             "$EXPORT_DIR/$FILE"
mv "$OUTPUT_FILE" "$EXPORT_DIR/$FILE"

# delay committing to prevent race conditions - Lunar
sleep "$(( $JOB_INDEX * 5 ))"