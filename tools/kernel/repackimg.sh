#!/sbin/sh
# AIK-mobile/repackimg: repack ramdisk and build image
# osm0sis @ xda-developers

case $0 in
  /system/bin/sh|sh)
    echo "Please run without using the source command.";
    echo "Example: sh ./repackimg.sh boot.img";
    return 1;;
esac;

abort() { cd "$PWD"; echo "Error!"; }

args="$*";
bin="$PWD/bin";
bb="$bin/busybox";
chmod -R 755 "$bin" "$PWD"/*.sh;
chmod 644 "$bin/magic";
cd "$PWD";

if [ -z "$(ls split_img/* 2> /dev/null)" ]; then
  echo "No files found to be packed/built.";
  abort;
  return 1;
fi;

clear;
echo "\nAndroid Image Kitchen - RepackImg Script";
echo "by osm0sis @ xda-developers\n";

if [ ! -z "$(ls *-new.* 2> /dev/null)" ]; then
  echo "Warning: Overwriting existing files!\n";
fi;

rm -f ramdisk-new.cpio*;
case $args in
  -o|--original)
    args=-o;
    echo "Repacking with original ramdisk...";;
  *)
    echo "Packing ramdisk...\n";
    ramdiskcomp=`cat split_img/*-ramdiskcomp`;
    echo "Using compression: $ramdiskcomp";
    repackcmd="$bb $ramdiskcomp";
    compext=$ramdiskcomp;
    case $ramdiskcomp in
      gzip) compext=gz;;
      lzop) compext=lzo;;
      xz) repackcmd="$bin/xz -1 -Ccrc32";;
      lzma) repackcmd="$bin/xz -Flzma";;
      bzip2) compext=bz2;;
      lz4) repackcmd="$bin/lz4 -l stdin stdout";;
    esac;
    $bin/mkbootfs ramdisk | $repackcmd > ramdisk-new.cpio.$compext;
    if [ $? == "1" ]; then
      abort;
      return 1;
    fi;;
esac;

echo "\nGetting build information...";
cd split_img;
kernel=`ls *-zImage`;               echo "kernel = $kernel";
if [ "$args" == "-o" ]; then
  ramdisk=`ls *-ramdisk.cpio*`;     echo "ramdisk = $ramdisk";
  ramdisk="split_img/$ramdisk";
else
  ramdisk="ramdisk-new.cpio.$compext";
fi;
cmdline=`cat *-cmdline`;            echo "cmdline = $cmdline";
base=`cat *-base`;                  echo "base = $base";
pagesize=`cat *-pagesize`;          echo "pagesize = $pagesize";
kerneloff=`cat *-kerneloff`;        echo "kernel_offset = $kerneloff";
ramdiskoff=`cat *-ramdiskoff`;      echo "ramdisk_offset = $ramdiskoff";
tagsoff=`cat *-tagsoff`;            echo "tags_offset = $tagsoff";
if [ -f *-second ]; then
  second=`ls *-second`;             echo "second = $second";
  second="--second split_img/$second";
  secondoff=`cat *-secondoff`;      echo "second_offset = $secondoff";
  secondoff="--second_offset $secondoff";
fi;
if [ -f *-dtb ]; then
  dtb=`ls *-dtb`;                   echo "dtb = $dtb";
  dtb="--dt split_img/$dtb";
fi;
cd ..;

echo "\nBuilding image...\n"
$bin/mkbootimg --kernel "split_img/$kernel" --ramdisk "$ramdisk" $second --cmdline "$cmdline" --base $base --pagesize $pagesize --kernel_offset $kerneloff --ramdisk_offset $ramdiskoff $secondoff --tags_offset $tagsoff $dtb -o image-new.img;
if [ $? == "1" ]; then
  abort;
  return 1;
fi;

echo "Done!";
return 0;

