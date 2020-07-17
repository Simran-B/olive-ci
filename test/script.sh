#!/bin/sh -v
_() {
    echo "==============================================================================="
}
_
uname -a
_
cat /etc/centos-release
_
lscpu
_
lshw -short
_
