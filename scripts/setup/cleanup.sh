#!/usr/bin/env bash

set -e -x

if [ -f .cleaned ]; then
  exit 0
fi

bosh -n target 127.0.0.1 lite
bosh login admin admin

bosh -n delete deployment --force cf-mysql
bosh -n delete deployment --force cf-warden
bosh -n delete deployment --force cf-warden-diego

# Credit:
#  - https://github.com/mitchellh/vagrant/issues/343
#  - https://github.com/chef/bento

echo "Deleting development packages ..."
dpkg --list \
    | awk '{ print $2 }' \
    | grep -- '-dev$' \
    | xargs apt-get -y purge;

echo "Deleting X11 libraries ..."
apt-get -y purge libx11-data xauth libxmuu1 libxcb1 libx11-6 libxext6;

echo "Deleting obsolete networking ..."
apt-get -y purge ppp pppconfig pppoeconf;

echo "Deleting oddities ..."
apt-get -y purge popularity-contest installation-report command-not-found command-not-found-data friendly-recovery;

echo "Cleaning up apt-get ..."
apt-get -y autoremove;
apt-get -y clean;

echo "Removing VirtualBox additions ISO ..."
rm -f VBoxGuestAdditions_*.iso VBoxGuestAdditions_*.iso.?;

echo "Removing caches ..."
find /var/cache -type f -exec rm -rf {} \;

echo "Removing bash history ..."
unset HISTFILE
rm -f /root/.bash_history
rm -f /home/vagrant/.bash_history

echo "Cleaning log files ..."
find /var/log -type f | while read f; do echo -ne '' > $f; done;

echo "Zeroing free space to aid VM compression ..."
set +e
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
set -e

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