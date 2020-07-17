#!/usr/bin/env bash

# Default working directory ${GITHUB_WORKSPACE} in GitHub Actions
mkdir -p /home/runner/work/olive-editor
cd /home/runner/work/olive-editor
git clone https://github.com/olive-editor/olive.git
cd olive

# HACK: Comment out -Wshadow which turns shadowing warnings into errors
sed -i -e "s/ -Wshadow/#-Wshadow/" app/CMakeLists.txt

# Compile
mkdir _build && cd _build
cmake .. -G "Ninja"
# TODO: Is the install prefix option needed here?
#       Does --prefix override it anyway?
#   cmake .. -G "Ninja" -DCMAKE_INSTALL_PREFIX=/usr
#   DESTDIR=appdir cmake --install app
cmake --build .

# Install
cmake --install app --prefix=appdir/usr

# Bundle
# TODO: Is /usr/local/lib64 non-standard?
ARCH=x86_64 \
LD_LIBRARY_PATH=/usr/local/lib64:\
/usr/local/lib/python3.7/site-packages/numpy/.libs:\
/usr/lib64/pulseaudio:\
$LD_LIBRARY_PATH \
\
/usr/local/linuxdeployqt-x86_64.AppImage \
  appdir/usr/share/applications/org.olivevideoeditor.Olive.desktop \
  -appimage \
  --appimage-extract-and-run

# TODO: Is this necessary to add? Seems to be included anyway
#   -extra-plugins=imageformats/libqsvg.so

# NOTE: AppImages require FUSE, but does not work in Docker containers
#   fuse: device not found, try 'modprobe fuse' first
# unless it is run with --privileged, which is dangerous.
# https://github.com/s3fs-fuse/s3fs-fuse/issues/647
# Better alternative: --appimage-extract-and-run
# https://github.com/probonopd/linuxdeployqt/issues/326

# TODO: Why did the following raise an error? Because of the * wildcard?
#   ./linuxdeployqt-continuous-x86_64.AppImage /usr/local/share/applications/*.desktop  -appimage --appimage-extract-and-run
#   ERROR: Unknown argument: "/usr/local/share/applications/org.olivevideoeditor.Olive.desktop"
# https://github.com/probonopd/linuxdeployqt/issues/237

# Resulting file: Olive-*-x86_64.AppImage (using $VERSION?)

# TODO: Fix ldd warnings?
# ERROR: findDependencyInfo: "ldd: warning: you do not have execution permission for *.so"

# HINT: Helpful env var in case of Qt runtime errors:
#   QT_DEBUG_PLUGINS=1 ./app/olive-editor
#   Cannot load library /usr/local/plugins/platforms/libqxcb.so: (libxkbcommon-x11.so.0: cannot open shared object file: No such file or directory)
#   QLibraryPrivate::loadPlugin failed on "/usr/local/plugins/platforms/libqxcb.so" : "Cannot load library /usr/local/plugins/platforms/libqxcb.so: (libxkbcommon-x11.so.0: cannot open shared object file: No such file or directory)"
#   qt.qpa.plugin: Could not load the Qt platform plugin "xcb" in "" even though it was found.
