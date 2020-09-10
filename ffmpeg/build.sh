#!/usr/bin/env bash
# Copyright (C) 2020 Olive Team
# SPDX-License-Identifier: GPL-3.0-or-later

set -ex

# TODO: Make wget less verbose about the download progress
# Maybe --progress=dot:mega --no-verbose ? In .wgetrc?
wget -O ffmpeg.tar.xz https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.xz
tar xf ffmpeg.tar.xz
cd ffmpeg*
PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH ./configure \
    --prefix=${OLIVE_INSTALL_PREFIX} \
    --extra-libs=-lpthread \
    --extra-libs=-lm \
    --enable-gpl \
    --enable-version3 \
    --enable-libfreetype \
    --enable-libmp3lame \
    --enable-libopus \
    --enable-libvpx \
    --enable-libx264 \
    --enable-libx265
make -j${NUM_JOBS}
make install
cd ..
rm -rf ffmpeg*

# TODO: Strip or build without executables /bin/ffmpeg and /bin/ffprobe?
