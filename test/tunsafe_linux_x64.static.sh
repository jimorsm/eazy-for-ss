#!/bin/sh
set -e

#RELARGS="-O3 -DNDEBUG"
#DBGARGS="-g -D_DEBUG"
#CURARGS="$RELARGS"
CURARGS="-static -s -static-libgcc -g0 -Os -DNDEBUG"
CXX=/mmx64/bin/x86_64-linux-musl-g++

$CXX -c -march=skylake-avx512 crypto/poly1305/poly1305-x64-linux.s crypto/chacha20/chacha20-x64-linux.s
$CXX -I . $CURARGS -DWITH_NETWORK_BSD=1 -mssse3 -pthread -lrt -o tunsafe \
tunsafe_amalgam.cpp \
crypto/aesgcm/aesni_gcm-x64-linux.s \
crypto/aesgcm/aesni-x64-linux.s \
crypto/aesgcm/ghash-x64-linux.s \
chacha20-x64-linux.o \
poly1305-x64-linux.o \
