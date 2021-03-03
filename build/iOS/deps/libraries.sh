#!/bin/bash -e

./irrlicht.sh
./freetype.sh
./libcurl.sh
#./gettext.sh ## doesn't work with older iOS versions
./openal.sh
./luajit.sh

echo
echo "All libraries were built!"
