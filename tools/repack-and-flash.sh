#!/sbin/sh

# get file descriptor for output (CWM)

OUTFD=$(ps | grep -v "grep" | grep -o -E "update_binary(.*)" | cut -d " " -f 3);

# get file descriptor for output (TWRP)
[ $OUTFD != "" ] || OUTFD=$(ps | grep -v "grep" | grep -o -E "updater(.*)" | cut -d " " -f 3)

# functions to send output to recovery
progress() {
  if [ $OUTFD != "" ]; then
    echo "progress ${1} ${2} " 1>&$OUTFD;
  fi;
}

set_progress() {
  if [ $OUTFD != "" ]; then
    echo "set_progress ${1} " 1>&$OUTFD;
  fi;
}

ui_print() {
  if [ $OUTFD != "" ]; then
    echo "ui_print ${1} " 1>&$OUTFD;
    echo "ui_print " 1>&$OUTFD;
  else
    echo "${1}";
  fi;
}

# make sure all the needed partitions are mounted so they show up in mount
# this may output errors if the partition is already mounted (/data and /cache probably will be), so pipe them to /dev/null
# make sure we mount /system before calling any additional shell scripts,
# because they may use /system/bin/sh instead of /sbin/sh and that may cause problems
mount /system 2> /dev/null
mount /cache 2> /dev/null
mount /data 2> /dev/null

# find out which partitions are formatted as F2FS
mount | grep -q 'data type f2fs'
DATA_F2FS=$?
mount | grep -q 'cache type f2fs'
CACHE_F2FS=$?
mount | grep -q 'system type f2fs'
SYSTEM_F2FS=$?

# unpack the boot.img and subsequently ramdisk via Android Image Kitchen by osm0sis (http://github.com/osm0sis)
cd /tmp/f2fs/tools/kernel/
./unpackimg.sh /tmp/f2fs/boot.img

ui_print "Boot.img unpacked."
set_progress 0.4

# copy the right fstab to the unpacked ramdisk
ui_print "Setting the right partition layout."

if [ $DATA_F2FS -eq 0 ] && [ $CACHE_F2FS -eq 0 ] && [ $SYSTEM_F2FS -eq 0 ]; then
	ui_print "All-F2FS partition layout found."
  cp -f /tmp/f2fs/fstab/fstab.qcom.all-F2FS /tmp/f2fs/tools/kernel/ramdisk/fstab.qcom
elif [ $DATA_F2FS -eq 0 ] && [ $CACHE_F2FS != 0 ] && [ $SYSTEM_F2FS != 0 ]; then
	ui_print "Data-F2FS partition layout found."
  cp -f /tmp/f2fs/fstab/fstab.qcom.data-F2FS /tmp/f2fs/tools/kernel/ramdisk/fstab.qcom
elif [ $DATA_F2FS != 0 ] && [ $CACHE_F2FS != 0 ] && [ $SYSTEM_F2FS != 0 ]; then
	ui_print "Standard EXT4 partition layout found."
  cp -f /tmp/f2fs/fstab/fstab.qcom.all-EXT4 /tmp/f2fs/tools/kernel/ramdisk/fstab.qcom
else
  ui_print "Unsupported partition layout found."
  ui_print "No changes were done to the device, exiting."
  exit
fi
set_progress 0.5

# repack the ramdisk and subsequently boot.img via Android Image Kitchen by osm0sis (http://github.com/osm0sis)
# no parameters are needed because they got saved by the unpacking
./repackimg.sh
ui_print "Boot.img repacked."
set_progress 0.7

# flash the repacked boot.img to the right partition
# not sure why flash-image doesn't work here, I always get error -1... so I have to dd it, not cool
# if anyone knows, please tell me :-)
dd if=/tmp/f2fs/tools/kernel/image-new.img of=/dev/block/platform/msm_sdcc.1/by-name/boot
ui_print "Boot.img flashed."
set_progress 0.9

