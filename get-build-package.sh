#!/bin/bash

# Script that installs build-package.sh to compile glibc packages

BRANCH="master"

git clone --depth 1 -b ${BRANCH} --single-branch https://github.com/termux/termux-packages.git

for i in build-package.sh clean.sh packages x11-packages root-packages scripts ndk-patches; do
	rm -fr ./${i}
	cp -r ./termux-packages/${i} ./
done

rm -fr termux-packages

# 1. استبدال القيم الأصلية المباشرة داخل ملف scripts/properties.sh
sed -i 's|TERMUX_APP_PACKAGE="com.termux"|TERMUX_APP_PACKAGE="com.wingo"|g' scripts/properties.sh
sed -i 's|TERMUX_PREFIX="/data/data/com.termux/files/usr"|TERMUX_PREFIX="/data/data/com.wingo/files/rootfs"|g' scripts/properties.sh
sed -i 's|TERMUX_PREFIX_CLASSICAL="/data/data/com.termux/files/usr"|TERMUX_PREFIX_CLASSICAL="/data/data/com.wingo/files/rootfs"|g' scripts/properties.sh
sed -i 's|TERMUX__PREFIX="/data/data/com.termux/files/usr"|TERMUX__PREFIX="/data/data/com.wingo/files/rootfs"|g' scripts/properties.sh

# 2. استبدال شامل لجميع قيم المسارات والمتغيرات في جميع ملفات المشروع (packages, scripts, ndk-patches)
# استبدال مسارات glibc المباشرة
find . -type f -exec sed -i 's|/data/data/com.termux/files/usr/glibc|/data/data/com.wingo/files/rootfs/glibc|g' {} +

# استبدال كافة المسارات التي تحتوي على /usr بالمسار الجديد /rootfs
find . -type f -exec sed -i 's|/data/data/com.termux/files/usr|/data/data/com.wingo/files/rootfs|g' {} +

# استبدال بقية المسارات العامة المتروكة
find . -type f -exec sed -i 's|/data/data/com.termux/files|/data/data/com.wingo/files/rootfs|g' {} +

# استبدال اسم الحزمة أينما وجد
find . -type f -exec sed -i 's|com.termux|com.wingo|g' {} +

echo "[+] Replaced all default values directly across the entire codebase."
