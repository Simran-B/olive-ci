#!/usr/bin/env bash

yum install --setopt=tsflags=nodocs -y epel-release
yum localinstall -y --nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm
yum install --setopt=tsflags=nodocs -y ffmpeg ffmpeg-devel