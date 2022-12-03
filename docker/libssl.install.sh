#!/bin/bash
arch=`cat /BUILDPLATFORM`

case $arch in
  'linux/amd64')
    echo "Installing AMD64 libssl 1.0.0"
    sleep 5

    wget http://snapshot.debian.org/archive/debian/20190501T215844Z/pool/main/g/glibc/multiarch-support_2.28-10_amd64.deb && \
    dpkg -i multiarch-support*.deb

    wget http://snapshot.debian.org/archive/debian-security/20190925T211341Z/pool/updates/main/o/openssl/libssl1.0.0_1.0.1t-1%2Bdeb8u12_amd64.deb && \
    dpkg -i libssl1.0.0_1.0.1t-1+deb8u12_amd64.deb
  ;;
  'linux/arm64')
    echo "Installing ARM64 libssl 1.0.0"
    sleep 5

    wget http://launchpadlibrarian.net/608324488/libssl1.0.0_1.0.2n-1ubuntu5.10_arm64.deb
    dpkg -i libssl1.0.0_1.0.2n-1ubuntu5.10_arm64.deb
  ;;
  *)
    echo "ACCEPTABLE ARCHITECTURE IS NOT PROVIDED"
  ;;
esac
