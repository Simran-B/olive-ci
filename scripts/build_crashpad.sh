#!/usr/bin/env bash
# Copyright (C) 2020 Olive Team
# SPDX-License-Identifier: GPL-3.0-or-later

set -ex

cd "${OLIVE_INSTALL_PREFIX}"

# Get Google's build tools
git clone --depth 1 https://chromium.googlesource.com/chromium/tools/depot_tools.git

# HACK: Compile our own gn. The one included in depot_tools requires GLIBC_2.18,
# but CentOS 7 only ships with GLIBC_2.17.
git clone https://gn.googlesource.com/gn
# NOTE: Don't clone with --depth 1, this will make build/gen.py fail!
cd gn
python build/gen.py
ninja -C out
cd ..
# Put the path to our own gn build first
PATH="$(pwd)/gn/out:$(pwd)/depot_tools:$PATH"
export PATH

# Build Crashpad with Clang (default)
# Toolchain can be controlled with env vars CC, CXX and AR
mkdir crashpad
cd crashpad
fetch crashpad
cd crashpad
# TODO: Use gn args out/Default or edit out/Default.args.gn to configure build?
# is_debug=true or target_cpu="x86"
gn gen out/Default
ninja -C out/Default

# TODO: Delete everyting we don't need in the package here?
