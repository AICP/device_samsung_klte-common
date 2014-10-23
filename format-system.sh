#!/sbin/sh

# find out the fs_type of /system so it is formatted correctly
mount | grep -q 'system type f2fs'
SYSTEM_F2FS=$?

if [ $SYSTEM_F2FS -eq 0 ]
then
    mkfs.f2fs /dev/block/platform/msm_sdcc.1/by-name/system
else
    mkfs.ext4 /dev/block/platform/msm_sdcc.1/by-name/system
fi
