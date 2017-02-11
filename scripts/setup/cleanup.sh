#!/usr/bin/env bash

set -e -x

if [ -f .cleaned ]; then
  exit 0
fi

# Credit:
#  - https://github.com/mitchellh/vagrant/issues/343
#  - https://github.com/chef/bento

echo "Removing caches ..."
find /var/cache -type f -exec rm -rf {} \;

echo "Cleaning log files ..."
find /var/log -type f | while read f; do echo -ne '' > $f; done;

echo "Zeroing free space to aid VM compression ..."
set +e
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
set -e

echo "Removing bash history ..."
unset HISTFILE
rm -f /root/.bash_history
rm -f /home/vagrant/.bash_history

echo "Whiting out root ..."
count=$(df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}')
count=$(($count-1))
set +e
dd if=/dev/zero of=/tmp/whitespace bs=1M count=$count || echo "dd exit code $? is suppressed";
rm /tmp/whitespace
set -e

echo "Whiting out /boot ..."
count=$(df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}')
count=$(($count-1))
set +e
dd if=/dev/zero of=/boot/whitespace bs=1M count=$count || echo "dd exit code $? is suppressed";
rm /boot/whitespace
set -e

echo "Removing swap ..."
set +e
swapuuid="`/sbin/blkid -o value -l -s UUID -t TYPE=swap`";
case "$?" in
    2|0) ;;
    *) exit 1 ;;
esac
set -e

if [ "x${swapuuid}" != "x" ]; then
    # Whiteout the swap partition to reduce box size
    # Swap is disabled till reboot
    swappart="`readlink -f /dev/disk/by-uuid/$swapuuid`";
    /sbin/swapoff "$swappart";
    dd if=/dev/zero of="$swappart" bs=1M || echo "dd exit code $? is suppressed";
    /sbin/mkswap -U "$swapuuid" "$swappart";
fi

set +x
sync;

touch .cleaned

echo ""
echo "*************************************"
echo "Provisioning completed successfully !"
echo "*************************************"
echo ""