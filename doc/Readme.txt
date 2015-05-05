Default Controls
-----------------
- WASD: move
- Space: jump/climb
- Shift: sneak/go down
- Q: drop itemstack (+ SHIFT for single item)
- I: inventory
- Mouse: turn/look
- Mouse left: dig/punch
- Mouse right: place/use
- Mouse wheel: select item
- T: chat
- 1-8: select item

- Esc: pause menu (pauses only singleplayer game)
- R: Enable/Disable full range view
- +: Increase view range
- -: Decrease view range
- K: Enable/Disable fly (needs fly privilege)
- J: Enable/Disable fast (needs fast privilege)
- H: Enable/Disable noclip (needs noclip privilege)

- F1:  Hide/Show HUD
- F2:  Hide/Show Chat
- F3:  Disable/Enable Fog
- F4:  Disable/Enable Camera update (Mapblocks are not updated anymore when disabled)
- F5:  Toogle through debug info screens
- F6:  Toogle through output data
- F7:  Toggle through camera modes
- F10: Show/Hide console
- F12: Take screenshot

- Settable in the configuration file, see the section below.

Paths
------
$bin   - Compiled binaries
$share - Distributed read-only data
$user  - User-created modifiable data

Windows .zip / RUN_IN_PLACE source:
$bin   = bin
$share = .
$user  = .

Linux installed:
$bin   = /usr/bin
$share = /usr/share/minetest
$user  = ~/.minetest

OS X:
$bin   = Contents/MacOS
$share = Contents/Resources
$user  = Contents/User OR ~/Library/Application Support/minetest

World directory
----------------
- Worlds can be found as separate folders in:
    $user/worlds/

Configuration file:
-------------------
- Default location:
    $user/minetest.conf
- It is created by Minetest when it is ran the first time.
- A specific file can be specified on the command line:
	--config <path-to-file>

Command-line options:
---------------------
- Use --help

Compiling on GNU/Linux:
-----------------------

Install dependencies. Here's an example for Debian/Ubuntu:
$ sudo apt-get install build-essential libirrlicht-dev cmake libbz2-dev libpng12-dev libjpeg8-dev libxxf86vm-dev libgl1-mesa-dev libsqlite3-dev libogg-dev libvorbis-dev libopenal-dev libcurl4-gnutls-dev libfreetype6-dev zlib1g-dev libjsoncpp-dev

You can install git for easily keeping your copy up to date.
If you dont want git, read below on how to get the source without git.
This is an example for installing git on Debian/Ubuntu:
$ sudo apt-get install git-core

Download source (this is the URL to the latest of source repository, which might not work at all times) using git:
$ git clone --depth 1 https://github.com/minetest/minetest.git
$ cd minetest

Download minetest_game (otherwise only the "Minimal development test" game is available) using git:
$ git clone --depth 1 https://github.com/minetest/minetest_game.git games/minetest_game

Download source, without using git:
$ wget https://github.com/minetest/minetest/archive/master.tar.gz
$ tar xf master.tar.gz
$ cd minetest-master

Download minetest_game, without using git:
$ cd games/
$ wget https://github.com/minetest/minetest_game/archive/master.tar.gz
$ tar xf master.tar.gz
$ mv minetest_game-master minetest_game
$ cd ..

Build a version that runs directly from the source directory:
$ cmake . -DRUN_IN_PLACE=TRUE
$ make -j <number of processors>

Run it:
$ ./bin/minetest

- Use cmake . -LH to see all CMake options and their current state
- If you want to install it system-wide (or are making a distribution package),
  you will want to use -DRUN_IN_PLACE=FALSE
- You can build a bare server by specifying -DBUILD_SERVER=TRUE
- You can disable the client build by specifying -DBUILD_CLIENT=FALSE
- You can select between Release and Debug build by -DCMAKE_BUILD_TYPE=<Debug or Release>
  - Debug build is slower, but gives much more useful output in a debugger
- If you build a bare server, you don't need to have Irrlicht installed.
  In that case use -DIRRLICHT_SOURCE_DIR=/the/irrlicht/source

CMake options
-------------
General options:

BUILD_CLIENT        - Build Minetest client
BUILD_SERVER        - Build Minetest server
CMAKE_BUILD_TYPE    - Type of build (Release vs. Debug)
    Release         - Release build
    Debug           - Debug build
    SemiDebug       - Partially optimized debug build
    RelWithDebInfo  - Release build with Debug information
    MinSizeRel      - Release build with -Os passed to compiler to make executable as small as possible
ENABLE_CURL         - Build with cURL; Enables use of online mod repo, public serverlist and remote media fetching via http
ENABLE_FREETYPE     - Build with FreeType2; Allows using TTF fonts
ENABLE_GETTEXT      - Build with Gettext; Allows using translations
ENABLE_GLES         - Search for Open GLES headers & libraries and use them
ENABLE_LEVELDB      - Build with LevelDB; Enables use of LevelDB map backend (faster than SQLite3)
ENABLE_REDIS        - Build with libhiredis; Enables use of Redis map backend
ENABLE_SOUND        - Build with OpenAL, libogg & libvorbis; in-game Sounds
ENABLE_LUAJIT       - Build with LuaJIT (much faster than non-JIT Lua)
RUN_IN_PLACE        - Create a portable install (worlds, settings etc. in current directory)
USE_GPROF           - Enable profiling using GProf
VERSION_EXTRA       - Text to append to version (e.g. VERSION_EXTRA=foobar -> Minetest 0.4.9-foobar)

Library specific options:

BZIP2_INCLUDE_DIR               - Linux only; directory where bzlib.h is located
BZIP2_LIBRARY                   - Linux only; path to libbz2.a/libbz2.so
CURL_DLL                        - Only if building with cURL on Windows; path to libcurl.dll
CURL_INCLUDE_DIR                - Only if building with cURL; directory where curl.h is located
CURL_LIBRARY                    - Only if building with cURL; path to libcurl.a/libcurl.so/libcurl.lib
EGL_INCLUDE_DIR                 - Only if building with GLES; directory that contains egl.h
EGL_LIBRARY                     - Only if building with GLES; path to libEGL.a/libEGL.so
FREETYPE_INCLUDE_DIR_freetype2  - Only if building with Freetype2; directory that contains an freetype directory with files such as ftimage.h in it
FREETYPE_INCLUDE_DIR_ft2build   - Only if building with Freetype2; directory that contains ft2build.h
FREETYPE_LIBRARY                - Only if building with Freetype2; path to libfreetype.a/libfreetype.so/freetype.lib
FREETYPE_DLL                    - Only if building with Freetype2 on Windows; path to libfreetype.dll
GETTEXT_DLL                     - Only when building with Gettext on Windows; path to libintl3.dll
GETTEXT_ICONV_DLL               - Only when building with Gettext on Windows; path to libiconv2.dll
GETTEXT_INCLUDE_DIR             - Only when building with Gettext; directory that contains iconv.h
GETTEXT_LIBRARY                 - Only when building with Gettext on Windows; path to libintl.dll.a
GETTEXT_MSGFMT                  - Only when building with Gettext; path to msgfmt/msgfmt.exe
IRRLICHT_DLL                    - path to Irrlicht.dll
IRRLICHT_INCLUDE_DIR            - directory that contains IrrCompileConfig.h
IRRLICHT_LIBRARY                - path to libIrrlicht.a/libIrrlicht.so/libIrrlicht.dll.a
LEVELDB_INCLUDE_DIR             - Only when building with LevelDB; directory that contains db.h
LEVELDB_LIBRARY                 - Only when building with LevelDB; path to libleveldb.a/libleveldb.so/libleveldb.dll.a
LEVELDB_DLL                     - Only when building with LevelDB on Windows; path to libleveldb.dll
REDIS_INCLUDE_DIR               - Only when building with Redis support; directory that contains hiredis.h
REDIS_LIBRARY                   - Only when building with Redis support; path to libhiredis.a/libhiredis.so
LUA_INCLUDE_DIR                 - Only if you want to use LuaJIT; directory where luajit.h is located
LUA_LIBRARY                     - Only if you want to use LuaJIT; path to libluajit.a/libluajit.so
MINGWM10_DLL                    - Only if compiling with MinGW; path to mingwm10.dll
OGG_DLL                         - Only if building with sound on Windows; path to libogg.dll
OGG_INCLUDE_DIR                 - Only if building with sound; directory that contains an ogg directory which contains ogg.h
OGG_LIBRARY                     - Only if building with sound; path to libogg.a/libogg.so/libogg.dll.a
OPENAL_DLL                      - Only if building with sound on Windows; path to OpenAL32.dll
OPENAL_INCLUDE_DIR              - Only if building with sound; directory where al.h is located
OPENAL_LIBRARY                  - Only if building with sound; path to libopenal.a/libopenal.so/OpenAL32.lib
OPENGLES2_INCLUDE_DIR           - Only if building with GLES; directory that contains gl2.h
OPENGLES2_LIBRARY               - Only if building with GLES; path to libGLESv2.a/libGLESv2.so
SQLITE3_INCLUDE_DIR             - Only if you want to use SQLite from your OS; directory that contains sqlite3.h
SQLITE3_LIBRARY                 - Only if you want to use the SQLite from your OS; path to libsqlite3.a/libsqlite3.so
VORBISFILE_DLL                  - Only if building with sound on Windows; path to libvorbisfile-3.dll
VORBISFILE_LIBRARY              - Only if building with sound; path to libvorbisfile.a/libvorbisfile.so/libvorbisfile.dll.a
VORBIS_DLL                      - Only if building with sound on Windows; path to libvorbis-0.dll
VORBIS_INCLUDE_DIR              - Only if building with sound; directory that contains a directory vorbis with vorbisenc.h inside
VORBIS_LIBRARY                  - Only if building with sound; path to libvorbis.a/libvorbis.so/libvorbis.dll.a
XXF86VM_LIBRARY                 - Only on Linux; path to libXXf86vm.a/libXXf86vm.so
ZLIB_DLL                        - Only on Windows; path to zlib1.dll
ZLIBWAPI_DLL                    - Only on Windows; path to zlibwapi.dll
ZLIB_INCLUDE_DIR                - directory where zlib.h is located
ZLIB_LIBRARY                    - path to libz.a/libz.so/zlibwapi.lib

Compiling on Windows:
---------------------
- This section is outdated. In addition to what is described here:
  - In addition to minetest, you need to download minetest_game.
  - If you wish to have sound support, you need libogg, libvorbis and libopenal

- You need:
	* CMake:
		http://www.cmake.org/cmake/resources/software.html
	* MinGW or Visual Studio
		http://www.mingw.org/
		http://msdn.microsoft.com/en-us/vstudio/default
	* Irrlicht SDK 1.7:
		http://irrlicht.sourceforge.net/downloads.html
	* Zlib headers (zlib125.zip)
		http://www.winimage.com/zLibDll/index.html
	* Zlib library (zlibwapi.lib and zlibwapi.dll from zlib125dll.zip):
		http://www.winimage.com/zLibDll/index.html
	* Optional: gettext library and tools:
		http://gnuwin32.sourceforge.net/downlinks/gettext.php
		- This is used for other UI languages. Feel free to leave it out.
	* And, of course, Minetest:
		http://minetest.net/download
- Steps:
	- Select a directory called DIR hereafter in which you will operate.
	- Make sure you have CMake and a compiler installed.
	- Download all the other stuff to DIR and extract them into there.
	  ("extract here", not "extract to packagename/")
	  NOTE: zlib125dll.zip needs to be extracted into zlib125dll
	- All those packages contain a nice base directory in them, which
	  should end up being the direct subdirectories of DIR.
	- You will end up with a directory structure like this (+=dir, -=file):
	-----------------
	+ DIR
		- zlib-1.2.5.tar.gz
		- zlib125dll.zip
		- irrlicht-1.7.1.zip
		- 110214175330.zip (or whatever, this is the minetest source)
		+ zlib-1.2.5
			- zlib.h
			+ win32
			...
		+ zlib125dll
			- readme.txt
			+ dll32
			...
		+ irrlicht-1.7.1
			+ lib
			+ include
			...
		+ gettext (optional)
			+bin
			+include
			+lib
		+ minetest
			+ src
			+ doc
			- CMakeLists.txt
			...
	-----------------
	- Start up the CMake GUI
	- Select "Browse Source..." and select DIR/minetest
	- Now, if using MSVC:
		- Select "Browse Build..." and select DIR/minetest-build
	- Else if using MinGW:
		- Select "Browse Build..." and select DIR/minetest
	- Select "Configure"
	- Select your compiler
	- It will warn about missing stuff, ignore that at this point. (later don't)
	- Make sure the configuration is as follows
	  (note that the versions may differ for you):
	-----------------
	BUILD_CLIENT             [X]
	BUILD_SERVER             [ ]
	CMAKE_BUILD_TYPE         Release
	CMAKE_INSTALL_PREFIX     DIR/minetest-install
	IRRLICHT_SOURCE_DIR      DIR/irrlicht-1.7.1
	RUN_IN_PLACE             [X]
	WARN_ALL                 [ ]
	ZLIB_DLL                 DIR/zlib125dll/dll32/zlibwapi.dll
	ZLIB_INCLUDE_DIR         DIR/zlib-1.2.5
	ZLIB_LIBRARIES           DIR/zlib125dll/dll32/zlibwapi.lib
	GETTEXT_BIN_DIR          DIR/gettext/bin
	GETTEXT_INCLUDE_DIR      DIR/gettext/include
	GETTEXT_LIBRARIES        DIR/gettext/lib/intl.lib
	GETTEXT_MSGFMT           DIR/gettext/bin/msgfmt
	-----------------
	- Hit "Configure"
	- Hit "Configure" once again 8)
	- If something is still coloured red, you have a problem.
	- Hit "Generate"
	If using MSVC:
		- Open the generated minetest.sln
		- The project defaults to the "Debug" configuration. Make very sure to
		  select "Release", unless you want to debug some stuff (it's slower
		  and might not even work at all)
		- Build the ALL_BUILD project
		- Build the INSTALL project
		- You should now have a working game with the executable in
			DIR/minetest-install/bin/minetest.exe
		- Additionally you may create a zip package by building the PACKAGE
		  project.
	If using MinGW:
		- Using the command line, browse to the build directory and run 'make'
		  (or mingw32-make or whatever it happens to be)
		- You may need to copy some of the downloaded DLLs into bin/, see what
		  running the produced executable tells you it doesn't have.
		- You should now have a working game with the executable in
			DIR/minetest/bin/minetest.exe

Windows releases of minetest are built using a bat script like this:
--------------------------------------------------------------------

set sourcedir=%CD%
set installpath="C:\tmp\minetest_install"
set irrlichtpath="C:\tmp\irrlicht-1.7.2"

set builddir=%sourcedir%\bvc10
mkdir %builddir%
pushd %builddir%
cmake %sourcedir% -G "Visual Studio 10" -DIRRLICHT_SOURCE_DIR=%irrlichtpath% -DRUN_IN_PLACE=TRUE -DCMAKE_INSTALL_PREFIX=%installpath%
if %errorlevel% neq 0 goto fail
"C:\WINDOWS\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe" ALL_BUILD.vcxproj /p:Configuration=Release
if %errorlevel% neq 0 goto fail
"C:\WINDOWS\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe" INSTALL.vcxproj /p:Configuration=Release
if %errorlevel% neq 0 goto fail
"C:\WINDOWS\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe" PACKAGE.vcxproj /p:Configuration=Release
if %errorlevel% neq 0 goto fail
popd
echo Finished.
exit /b 0

:fail
popd
echo Failed.
exit /b 1