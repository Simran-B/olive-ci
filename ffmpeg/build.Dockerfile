# Copyright (C) 2020 Olive Team
# SPDX-License-Identifier: GPL-3.0-or-later

# FFmpeg 4.2 (GPL3) for CentOS 7
#
# Largely copied from https://trac.ffmpeg.org/wiki/CompilationGuide/Centos

ARG FFMPEG_VERSION=4.2.4

FROM olivevideoeditor/ffmpeg-base as ffmpeg-builder

ARG FFMPEG_VERSION
ARG NUM_JOBS=1

LABEL maintainer="olivevideoeditor@gmail.com"

LABEL org.opencontainers.image.name="olivevideoeditor/ffmpeg-base"
LABEL org.opencontainers.image.description="CentOS Build Image for FFMPEG"
LABEL org.opencontainers.image.url="http://olivevideoeditor.org"
LABEL org.opencontainers.image.source="https://github.com/olive-editor/olive"
LABEL org.opencontainers.image.vendor="Olive Team"
LABEL org.opencontainers.image.version="1.0"

COPY ffmpeg/build.sh \
     scripts/common/before_build.sh \
     scripts/common/copy_new_files.sh \
     /tmp/

ENV FFMPEG_VERSION=${FFMPEG_VERSION} \
    OLIVE_INSTALL_PREFIX=/usr/local \
    NUM_JOBS=${NUM_JOBS}

RUN /tmp/before_build.sh && \
    /tmp/build.sh && \
    /tmp/copy_new_files.sh

FROM scratch as ffmpeg

COPY --from=ffmpeg-builder /package/. /
