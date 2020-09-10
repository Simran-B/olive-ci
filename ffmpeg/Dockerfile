# Copyright (C) 2020 Olive Team
# SPDX-License-Identifier: GPL-3.0-or-later

# FFmpeg 4.2 (GPL3) for CentOS 7
#
# Largely copied from https://trac.ffmpeg.org/wiki/CompilationGuide/Centos

FROM centos:7 as ffmpeg-base

ARG NASM_VERSION=2.15.03
ARG YASM_VERSION=1.3.0
ARG LAME_VERSION=3.100
ARG OPUS_VERSION=1.3.1
# TODO: Make version of x264, x265 and libvpx selectable?
ARG NUM_JOBS=1

LABEL maintainer="olivevideoeditor@gmail.com"

LABEL org.opencontainers.image.name="olivevideoeditor/ci-ffmpeg"
LABEL org.opencontainers.image.description="CentOS Base Image for FFMPEG"
LABEL org.opencontainers.image.url="http://olivevideoeditor.org"
LABEL org.opencontainers.image.source="https://github.com/olive-editor/olive"
LABEL org.opencontainers.image.vendor="Olive Team"
LABEL org.opencontainers.image.version="1.0"

USER root

COPY ffmpeg/install_deps.sh \
     /tmp/

ENV NASM_VERSION=${NASM_VERSION} \
    YASM_VERSION=${YASM_VERSION} \
    LAME_VERSION=${LAME_VERSION} \
    OPUS_VERSION=${OPUS_VERSION} \
    OLIVE_INSTALL_PREFIX=/usr/local \
    LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64:$LD_LIBRARY_PATH \
    NUM_JOBS=${NUM_JOBS}

RUN /tmp/install_deps.sh
