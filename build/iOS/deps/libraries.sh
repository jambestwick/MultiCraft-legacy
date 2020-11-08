#!/bin/bash -e

./irrlicht.sh
./freetype.sh
./libcurl.sh
#./gettext.sh ## doesn't work with older iOS versions
./openal.sh
#./luajit.sh ## requires an older version of macOS (with 32-bit support)

echo
echo "All libraries were built!"
