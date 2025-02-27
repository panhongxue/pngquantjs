#!/bin/bash
# script to build pngquant.js using pngquant source
# This scripts assumes it is being executed in emscripten environment, where
# emcc and other emscripten variables are used. In order to ease up the things
# I have created a docker with emscripten environment. Docker image is available
# as psych0der/emscripten and can be used by `docker pull psych0der/emscripten`


# exit on first error
set -e

# sourc directory of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIST=$DIR/dist

# Make sure dist exists
mkdir -p $DIST


# install libpng-dev16. Installing libpng-dev16 is important since we are going
# to link our compiled pngquant static lib with libpng compiled for emscripten by
# emscripten folks. They are using libpng-16 so its emperative to use this version
# when linking the header files to avoid disparities later

apt-get install -y libpng-dev make

# compile zlib
cd $DIR/deps/pngquant/zlib
emconfigure ./configure # --64
emmake make

# change dir to deps
cd $DIR/deps/pngquant

# start configuring script
emconfigure ./configure --disable-sse --with-libpng=/usr/include --extra-cflags="-sUSE_LIBPNG=1 -sTOTAL_MEMORY=1048576000 --proxy-to-worker " #--enable-debug

# At this point just make sure that config.mk file points correct version of
# libpng

emmake make

# pngquant Makefile is configured to create executable by the name of pngquant
# But since we are using emscripten the file actually creted is bitecode file.
# So we need to rename it

# mv pngquant pngquant.bc

# Time to rumble. Create our mighty js file
# emcc -03 pngquant.bc  -s TOTAL_MEMORY=335544320  -s USE_LIBPNG=1 -s USE_ZLIB=1  --pre-js ../../pre.js --post-js ../../post.js -s WASM=1  -o pngquant.js

# wasm
# emcc -03 pngquant.o  -s TOTAL_MEMORY=335544320  -s USE_LIBPNG=1  -s USE_ZLIB=1  --proxy-to-worker -s WASM=1  -o pngquant.js
# asm
#emcc -03 pngquant.bc  -s TOTAL_MEMORY=335544320  -s USE_LIBPNG=1  -s USE_ZLIB=1  --pre-js ../../pre.js --post-js ../../post.js  --proxy-to-worker -s WASM=0  -o pngquant.asm.js


# copy our js file to dist folder
mv pngquant.js $DIST/
mv pngquant.worker.js $DIST/
mv pngquant.wasm $DIST/
# mv pngquant.asm.js $DIST/

echo "pngquant.js has been successfully compiled  and placed in $DIST"
