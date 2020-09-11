#!/usr/bin/env bash
# Copyright (C) 2020 Olive Team
# SPDX-License-Identifier: GPL-3.0-or-later

# Uses { command } & pattern for parallelism https://gist.github.com/thenadz/6c0584d42fb007582fbc

# TOOD: Use advanced options such as LTO? e.g. https://code.videolan.org/videolan/x264/-/blob/master/configure

# TODO: Create ci-common image (subset of ci-base), to use it for olive & ffmpeg compilation.
#       Not available in current olive-ci-centos image:
#       bzip2-devel, freetype-devel, mercurial, wget

set -ex

yum update -y

# Install base dependencies
yum install --setopt=tsflags=nodocs -y \
    autoconf \
    automake \
    bzip2 \
    bzip2-devel \
    cmake \
    freetype-devel \
    gcc \
    gcc-c++ \
    git \
    libtool \
    make \
    mercurial \
    pkgconfig \
    wget \
    zlib-devel

yum clean all

# Set up recent NASM
{
    wget -O nasm.tar.xz https://www.nasm.us/pub/nasm/releasebuilds/${NASM_VERSION}/nasm-${NASM_VERSION}.tar.xz
    tar xf nasm.tar.xz
    rm -f nasm.tar.xz
    cd nasm*
    ./autogen.sh
    ./configure --prefix=${OLIVE_INSTALL_PREFIX}
    make -j${NUM_JOBS}
    make install
    cd ..
    rm -rf nasm*
} &

# Set up recent YASM
{
    wget -O yasm.tar.gz http://www.tortall.net/projects/yasm/releases/yasm-${YASM_VERSION}.tar.gz
    tar xf yasm.tar.gz
    rm -f yasm.tar.gz
    cd yasm*
    ./configure --prefix=${OLIVE_INSTALL_PREFIX}
    make -j${NUM_JOBS}
    make install
    cd ..
    rm -rf yasm*
} &

# join jobs, some libs depend on NASM/YASM
wait

# Set up libx264
{
    git clone --depth 1 https://code.videolan.org/videolan/x264.git
    cd x264
    ./configure --enable-shared --prefix=${OLIVE_INSTALL_PREFIX}
    make -j${NUM_JOBS}
    make install
    cd ..
    rm -rf x264
} &

# Set up libx265
{
    hg clone https://bitbucket.org/multicoreware/x265
    cd x265/build/linux
    cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=${OLIVE_INSTALL_PREFIX} ../../source
    make -j${NUM_JOBS}
    make install
    cd ../../..
    rm -rf x265
} &

# Set up libmp3lame
{
    wget -O lame.tar.gz https://downloads.sourceforge.net/project/lame/lame/${LAME_VERSION}/lame-${LAME_VERSION}.tar.gz
    tar xf lame.tar.gz
    rm -f lame.tar.gz
    cd lame*
    ./configure --enable-nasm --prefix=${OLIVE_INSTALL_PREFIX}
    make -j${NUM_JOBS}
    make install
    cd ..
    rm -rf lame*
} &

# Set up libopus
{
    wget -O opus.tar.gz https://archive.mozilla.org/pub/opus/opus-${OPUS_VERSION}.tar.gz
    tar xf opus.tar.gz
    rm -f opus.tar.gz
    cd opus*
    ./configure --prefix=${OLIVE_INSTALL_PREFIX}
    make -j${NUM_JOBS}
    make install
    cd ..
    rm -rf opus*
} &

# Set up libvpx
{
    git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
    cd libvpx
    ./configure --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm --prefix=${OLIVE_INSTALL_PREFIX}
    make -j${NUM_JOBS}
    make install
    cd ..
    rm -rf libvpx
} &

# join all jobs
wait
