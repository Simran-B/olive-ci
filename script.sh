#!/bin/sh -v
_() {
    printf '=%.0s' {1..80}
    printf '\n'
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
