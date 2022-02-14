#!/bin/bash -e

./irrlicht.sh
./freetype.sh
./libcurl.sh
./gettext.sh
./openal.sh
./luajit.sh

echo
echo "All libraries were built!"
