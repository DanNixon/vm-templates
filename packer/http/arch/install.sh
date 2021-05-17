#!/bin/sh

set -ex

DISK='/dev/sda'
TARGET_DIR='/mnt'
MIRRORLIST="https://archlinux.org/mirrorlist/?country=GB&country=DE&protocol=http&protocol=https&ip_version=4&use_mirror_status=on"
CONFIG_SCRIPT='/usr/local/bin/arch-config.sh'

# Clear partition table
sgdisk --zap "$DISK"

# Destroy magic strings and signatures
dd if=/dev/zero of="$DISK" bs=512 count=2048
wipefs --all "$DISK"

# Create boot partition
sgdisk --new=1:0:+1M "$DISK"
sgdisk --typecode=1:ef02 "$DISK"

# Create LVM physical volume
sgdisk --largest-new=2 "$DISK"
sgdisk --typecode=2:8304 "$DISK"
pvcreate "${DISK}2"

# Create LVM volume group
vgcreate arch "${DISK}2"

# Create LVM root volume
lvcreate --extents 100%FREE --name root arch
ROOT_PART='/dev/mapper/arch-root'

# Create root filesystem
mkfs.ext4 -O ^64bit -F -m 0 -q -L root "$ROOT_PART"

# Mount root filesystem
mount -o noatime,errors=remount-ro "$ROOT_PART" "$TARGET_DIR"

# Set mirror list
curl -s "$MIRRORLIST" | sed 's/^#Server/Server/' > /etc/pacman.d/mirrorlist

# Install
pacstrap "$TARGET_DIR" \
  base \
  base-devel \
  bc \
  cloud-init \
  grub \
  gptfdisk \
  iptables-nft \
  linux \
  lvm2 \
  openssh \
  parted \
  qemu-guest-agent

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Configure system
cp config.sh "${TARGET_DIR}${CONFIG_SCRIPT}"
chmod +x "${TARGET_DIR}${CONFIG_SCRIPT}"
arch-chroot "$TARGET_DIR" "$CONFIG_SCRIPT"
rm "${TARGET_DIR}${CONFIG_SCRIPT}"

# Unmount root partition
sync
umount "$TARGET_DIR"

reboot
