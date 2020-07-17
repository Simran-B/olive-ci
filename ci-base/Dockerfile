# TODO: Fix name, this is a complete CI image. Should include OS name.

ARG OLIVE_ORG=olive-editor

ARG ASWF_PKG_ORG=aswftesting
ARG VFXPLATFORM_VERSION=2021
ARG CI_COMMON_VERSION=2

FROM ${ASWF_PKG_ORG}/ci-package-qt:${VFXPLATFORM_VERSION} as ci-package-qt
FROM ${ASWF_PKG_ORG}/ci-package-python:${VFXPLATFORM_VERSION} as ci-package-python
FROM ${ASWF_PKG_ORG}/ci-package-boost:${VFXPLATFORM_VERSION} as ci-package-boost
FROM ${ASWF_PKG_ORG}/ci-package-openexr:${VFXPLATFORM_VERSION} as ci-package-openexr
FROM ${ASWF_PKG_ORG}/ci-package-oiio:${VFXPLATFORM_VERSION} as ci-package-oiio
FROM ${ASWF_PKG_ORG}/ci-package-ocio:${VFXPLATFORM_VERSION} as ci-package-ocio
FROM ${ASWF_PKG_ORG}/ci-package-clang:${CI_COMMON_VERSION} as ci-package-clang
FROM ${ASWF_PKG_ORG}/ci-package-ninja:${CI_COMMON_VERSION} as ci-package-ninja

FROM centos:7 as ci-base

# TODO: Is there an official email address?
LABEL maintainer="mail@olivevideoeditor.org"

LABEL org.opencontainers.image.name="$OLIVE_ORG/ci-centos"
LABEL org.opencontainers.image.description="CentOS CI Docker Image"
LABEL org.opencontainers.image.url="http://olivevideoeditor.org"
LABEL org.opencontainers.image.source="https://github.com/olive-editor/olive"
LABEL org.opencontainers.image.vendor="Olive Team"
LABEL org.opencontainers.image.version="1.0"

USER root

COPY --from=ci-package-qt /. /usr/local/
COPY --from=ci-package-python /. /usr/local/
COPY --from=ci-package-boost /. /usr/local/
COPY --from=ci-package-openexr /. /usr/local/
COPY --from=ci-package-oiio /. /usr/local/
COPY --from=ci-package-ocio /. /usr/local/
COPY --from=ci-package-clang /. /usr/local/
COPY --from=ci-package-ninja /. /usr/local/

COPY scripts/base/install_cmake.sh \
     /tmp/

RUN export DOWNLOADS_DIR=/tmp/downloads && \
    export CMAKE_VERSION=3.18.0 && \
    mkdir /tmp/downloads && \
#   source /tmp/versions_base.sh && \
    /tmp/install_cmake.sh && \
#   /tmp/patchup.sh && \
    rm -rf /tmp/downloads

RUN curl --location "https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage" \
      -o "/usr/local/linuxdeployqt-x86_64.AppImage" && \
    chmod a+x "/usr/local/linuxdeployqt-x86_64.AppImage"
# TODO: Set env vars here, e.g. for linuxdeployqt?
#   ENV ARCH=x86_64 \
#       LD_LIBRARY_PATH=/usr/local/lib64:/usr/local/lib/python3.7/site-packages/numpy/.libs:/usr/lib64/pulseaudio:$LD_LIBRARY_PATH
# aswf-docker:
#   ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64:/opt/rh/httpd24/root/usr/lib64:/opt/rh/devtoolset-${DTS_VERSION}/root/usr/lib64:/opt/rh/devtoolset-${DTS_VERSION}/root/usr/lib:${LD_LIBRARY_PATH} \

COPY scripts/common/install_yumpackages.sh \
     scripts/build.sh \
     /tmp/

RUN /tmp/install_yumpackages.sh

# Usage:
#   docker build -t olive-editor/ci-base -f ci-base\Dockerfile .
#   docker run --rm -it olive-editor/ci-base
