#!/bin/bash

set -e
set -x

# sync rom
repo init --depth=1 -u git://github.com/Corvus-R/android_manifest -b 12-test
git clone https://github.com/zeelog/android_device_xiaomi_mido --depth 1 -b lineage-19.1 .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)

# build rom
source build/envsetup.sh
lunch aosp_mido-user
m aex -j$(nproc --all)

# upload rom
up(){
	curl --upload-file $1 https://transfer.sh/$(basename $1); echo
	# 14 days, 10 GB limit
}

up out/target/product/mido/*.zip
