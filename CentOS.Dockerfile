ARG baseimage=centos:7
FROM ${baseimage} AS centosbase
#RUN yum check-update
# A note about vsyscall https://hub.docker.com/_/centos/ 
#RUN cat /proc/self/maps | egrep 'vdso|vsyscall'
RUN yum -y install lshw

# Equivalent of installing build-essentials for CentOS:
#RUN yum -y install gcc gcc-c++ make
# Also kernel-devel kernel-headers binutils?
# WARN: Installs old GCC from 2015 (v4.8.5)

#RUN yum groupinstall "Development Tools" # ALL development tools

# However, vfxplatform.com suggests the following:
#RUN yum -y install centos-release-scl
#RUN yum -y install devtoolset-6
# ERROR: No package devtoolset-6 available.

# Use ready-made image? https://www.softwarecollections.org/en/scls/rhscl/devtoolset-6/
# docker pull centos/devtoolset-6-perftools-centos7
# docker pull centos/devtoolset-6-toolchain-centos7

#COPY entrypoint.sh /entrypoint.sh
#RUN ["chmod", "+x", "/entrypoint.sh"]
#ENTRYPOINT ["/entrypoint.sh"]

COPY script.sh /script.sh
#RUN ["chmod", "+x", "/script.sh"]
