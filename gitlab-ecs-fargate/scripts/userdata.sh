#!/bin/bash
sudo  su

yum install -y lvm2

set -ex 

vgchange -ay

DEVICE_FS=`blkid -o value -s TYPE ${DEVICE} || echo ""`
if [ "`echo -n $DEVICE_FS`" == "" ] ; then 
  # wait for the device to be attached
  DEVICENAME=`echo "${DEVICE}" | awk -F '/' '{print $3}'`
  DEVICEEXISTS=''
  while [[ -z $DEVICEEXISTS ]]; do
    echo "checking $DEVICENAME"
    DEVICEEXISTS=`lsblk |grep "$DEVICENAME" |wc -l`
    if [[ $DEVICEEXISTS != "1" ]]; then
      sleep 15
    fi
  done
  pvcreate ${DEVICE}
  vgcreate data ${DEVICE}
  lvcreate --name volume1 -l 100%FREE data
  mkfs.ext4 /dev/data/volume1
fi

# if [ -e ${EXT_DEVICE} ]; then
#    pvcreate -y ${EXT_DEVICE}
#    vgextend data ${EXT_DEVICE}
#    lvextend /dev/data/volume1 ${EXT_DEVICE}

#    # for the case of extending ext4 filesystem
#    resize2fs /dev/data/volume1
# fi

mkdir -p /data
echo '/dev/data/volume1 /data ext4 defaults 0 0' >> /etc/fstab
mount /data

# install docker
curl https://get.docker.com | bash
