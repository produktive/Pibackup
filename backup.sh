#!/bin/bash
# script to backup Pi SD card
# DSK='disk4'   # manual set disk
cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1
OUTDIR=$PWD

# Find disk with Linux partition (works for Raspbian)
# Modified for PINN/NOOBS
export DSK=`diskutil list | grep "Linux" | sed 's/.*\(disk[0-9]\).*/\1/' | uniq`
if [ $DSK ]; then
    echo $DSK
    echo $OUTDIR
else
    echo "Disk not found"
    exit
fi

if [ $# -eq 0 ] ; then
    BACKUPNAME='Pi'
else
    BACKUPNAME=$1
fi
BACKUPNAME+="back"
echo $BACKUPNAME

diskutil unmountDisk /dev/$DSK
echo Please wait - this takes some time
time sudo dd status=progress if=/dev/r$DSK bs=4m | gzip -9 > "$OUTDIR/Piback.img.gz"

#rename to current date
echo Compressing completed - now renaming
mv -n "$OUTDIR/Piback.img.gz" "$OUTDIR/$BACKUPNAME`date -I`.gz"