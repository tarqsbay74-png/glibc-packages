#!/bin/bash

# Script that installs build-package.sh to compile glibc packages

BRANCH="master"

git clone --depth 1 -b ${BRANCH} --single-branch https://github.com/termux/termux-packages.git

for i in build-package.sh clean.sh packages x11-packages root-packages scripts ndk-patches; do
	rm -fr ./${i}
	cp -r ./termux-packages/${i} ./
done

rm -fr termux-packages

# تعيين المسار المخصص داخل ملف الخصائص مباشرة
cat << 'EOF' >> scripts/properties.sh

# Custom prefix path override
TERMUX_APP_PACKAGE="com.wingo"
TERMUX_PREFIX="/data/data/com.wingo/files/rootfs"
TERMUX_PREFIX_CLASSICAL="$TERMUX_PREFIX"
TERMUX__PREFIX="$TERMUX_PREFIX"
EOF
