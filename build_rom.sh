#!/bin/bash

set -e
set -x

# sync rom
repo init -u https://github.com/LineageOS/android.git -b lineage-18.1
git clone https://github.com/Yshmany/local_manifests.git --depth 1 -b main .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)

# build rom
source build/envsetup.sh
lunch lineage_channel-user
m aex -j$(nproc --all)

# upload rom
up(){
	curl --upload-file $1 https://transfer.sh/$(basename $1); echo
	# 14 days, 10 GB limit
}

up out/target/product/mido/*.zip
