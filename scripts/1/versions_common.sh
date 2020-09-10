#!/usr/bin/env bash
# Copyright (c) Contributors to the aswf-docker Project. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

set -ex

export DTS_VERSION=6
export CLANG_VERSION=7.0.1
export NINJA_VERSION=1.10.0
export PKGS_COMMON_CMAKE_VERSION=3.18.1 # Only used to build common packages