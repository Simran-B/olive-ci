#!/usr/bin/env bash
# Copyright (C) 2020 Olive Team
# SPDX-License-Identifier: GPL-3.0-or-later

set -ex

cd "${OLIVE_INSTALL_PREFIX}"

# Get Google's build tools
git clone --depth 1 https://chromium.googlesource.com/chromium/tools/depot_tools.git

# HACK: Compile our own gn. The one included in depot_tools requires GLIBC_2.18,
# but CentOS 7 only ships with GLIBC_2.17.
# NOTE: Don't clone with --depth 1, this will make build/gen.py fail!
git clone https://gn.googlesource.com/gn
cd gn
python build/gen.py
ninja -C out
# cp is typically an alias for cp -i (interactive), which -f does not override.
# \cp or command cp will avoid the alias and use the underlaying command.
#command cp -f out/gn ../depot_tools/gn
cd ..
# Put the path to our own gn build first
export PATH="$(pwd)/gn/out:$(pwd)/depot_tools:$PATH"

# Build Crashpad with Clang (default)
mkdir crashpad
cd crashpad
fetch crashpad
cd crashpad
gn gen out/Default
ninja -C out/Default

# TODO: Use gn args out/Default or edit out/Default.args.gn to configure build?
# is_debug=true or target_cpu="x86"

#cd ../..
#git clone --depth 1 https://github.com/olive-editor/olive.git
#cd olive
#mkdir build
#cd build
#cmake .. -G Ninja
#cmake --build .
#cmake --install app --prefix appdir/usr
#/usr/local/linuxdeployqt-x86_64.AppImage appdir/usr/share/applications/org.olivevideoeditor.Olive.desktop -appimage --appimage-extract-and-run
