# Smallest base image
FROM alpine:3.5

MAINTAINER John Felten<john.felten@gmail.com>

ADD VERSION .

# Install needed packages
RUN echo "http://dl-4.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories && \
    echo "http://dl-4.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk update && apk add openvpn openvpn-dev autoconf re2c libtool \
	     openldap-dev  gcc-objc make git openssl easy-rsa iptables bash && \
    git clone https://github.com/snowrider311/openvpn-auth-ldap && \
     cd /openvpn-auth-ldap && \
     ./regen.sh && \
     ./configure --with-openvpn=/usr/include/openvpn CFLAGS="-fPIC" OBJCFLAGS="-std=gnu11" && \
     make && make install && \
     rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/* /openvpn-auth-ldap

# Configure tun
RUN mkdir -p /dev/net && \
     mknod /dev/net/tun c 10 200 

