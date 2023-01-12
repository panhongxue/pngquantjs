# Pngquant.js
Pngquant.js is a port of [pngquant](https://github.com/pornel/pngquant) lib in js, made possible by [emscripten](https://github.com/kripken/emscripten) which compiles LLVM bit code generated from c/c++ directly to javascript. Pngquant js can compress png images right in your browser without any server requirements. This can open a wide array of possibilities of what can be achieved on a browser, with clients compressing the static assets on their device itself, saving precious bandwidth.

### Build

> emcc version: 1.7.3

This version of pngquantjs is built using v2.9.0 of [pngquant](https://github.com/kornelski/pngquant/tree/b023ac36269efb8f9095c0b22f76cd7951ed6432). Original [configure script](pngquant/configure) needs to be patched in order to be used by emscripten. Patched version of this file is present in the deps folder in this directory. Additionally, patch file for configure script is also present in the repository in order to create a fresh copy. Build script assumes that emscripten is already built and available in the system path. Once this is ensured, just run `./build.sh` which will initiate build process and pngquant.js will be available in dist folder.
This file can be easily compressed using uglify.js. I haven't included the command to use uglify.js in the build script (planning to do so soon), but a minified version of pngquant.js is included in the demo folder.
Since the process of setting up emscripten is tedious and may pollute the global namespace, I have created a docker image which comes preinstalled with emscripten and all environments initialized. It's available at [this](https://hub.docker.com/r/psych0der/emscripten/) link and can be used by issuing `
docker pull psych0der/emscripten` command. I would recommend using docker image since it greatly simplifies working with emscripten without thinking about any installation issue.

### Demo
[https://psych0der.github.io/pngquantjs/](https://psych0der.github.io/pngquantjs/)

## License

* Under **GPL v3** with an additional [copyright notice](https://github.com/kornelski/pngquant/blob/master/COPYRIGHT)
