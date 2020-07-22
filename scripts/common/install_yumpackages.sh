#!/usr/bin/env bash
# Copyright (C) 2019 Olive Team
# Copyright (c) Contributors to the aswf-docker Project. All rights reserved.
# SPDX-License-Identifier: Apache-2.0 OR GPL-3.0-or-later

set -ex

yum install --setopt=tsflags=nodocs -y \
    cups-libs \
    giflib-devel \
    gstreamer1 gstreamer1-devel \
    gstreamer1-plugins-bad-free gstreamer1-plugins-bad-free-devel \
    libicu-devel \
    libmng-devel \
    LibRaw-devel \
    libwebp-devel \
    libXcomposite libXcomposite-devel \
    libXcursor libXcursor-devel \
    libxkbcommon libxkbcommon-devel \
    libxkbcommon-x11-devel \
    libXScrnSaver libXScrnSaver-devel \
    mesa-libGL-devel \
    pciutils-devel \
    pulseaudio-libs pulseaudio-libs-devel \
    python3-tkinter \
    zlib-devel

# HACK: Qt5GuiConfigExtras.cmake expects libGL.so in /usr/local/lib64 but it gets installed to /usr/lib64
cd /usr/local/lib64/ && ln -s /usr/lib64/libGL.so
# Alternatively, we could edit /usr/local/lib/cmake/Qt5Gui/Qt5GuiConfigExtras.cmake
# - _qt5gui_find_extra_libs(OPENGL "/usr/local/lib64/libGL.so" "" "")
# + _qt5gui_find_extra_libs(OPENGL "/usr/lib64/libGL.so" "" "")

yum -y groupinstall "Development Tools"

# TODO: Below code would install the obsolete devtoolset-6.
#       Unclear which devtoolset it will be for VFX platform CY2021:
#       https://groups.google.com/forum/#!topic/vfx-platform-discuss/_-_CPw1fD3c

#yum install -y --setopt=tsflags=nodocs centos-release-scl-rh yum-utils
#
#if [[ $DTS_VERSION == 6 ]]; then
#    # Use the centos vault as the original devtoolset-6 is not part of CentOS-7 anymore
#    sed -i 's/7/7.6.1810/g; s|^#\s*\(baseurl=http://\)mirror|\1vault|g; /mirrorlist/d' /etc/yum.repos.d/CentOS-SCLo-*.repo
#fi
#
#yum install -y --setopt=tsflags=nodocs \
#    devtoolset-$DTS_VERSION-toolchain
#
#yum install -y epel-release

# TODO: Use Docker image instead similar to the other package in Dockerfile
# Maybe this: https://github.com/jrottenberg/ffmpeg/blob/master/docker-images/4.3/centos7/Dockerfile
# Current solution from: https://linuxize.com/post/how-to-install-ffmpeg-on-centos-7/
yum install --setopt=tsflags=nodocs -y epel-release
yum localinstall -y --nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm
yum install --setopt=tsflags=nodocs -y ffmpeg ffmpeg-devel
# TODO: Does the nodocs flag do anything here?

# Many IUS packages have dependencies from EPEL repo, see https://ius.io/setup
yum install -y \
    https://repo.ius.io/ius-release-el7.rpm \
    https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# actions/checkout@v2 needs at least Git 2.18 to not just download an archive
# https://github.com/actions/checkout/issues/238#issuecomment-633750110
# If Git is used for cloning, then linuxdeployqt will use the short commit hash
# in the AppImage name without explicitly setting the VERSION env var.
yum swap -y git git224-core
