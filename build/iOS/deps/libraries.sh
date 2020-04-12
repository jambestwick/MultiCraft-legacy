#!/bin/bash -e

./irrlicht.sh
./freetype.sh
./libcurl.sh
#./luajit.sh ## requires an older version of macOS (with 32-bit support)

echo
echo "All libraries were built!"
