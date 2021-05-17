#!/bin/sh

set -ex

DISK='/dev/sda'

# Set hostname
echo "archlinux" > /etc/hostname

# Create initramfs
sed -i 's/HOOKS=.*/HOOKS=(base udev autodetect modconf block filesystems keyboard fsck btrfs)/' /etc/mkinitcpio.conf
mkinitcpio -P

# Install GRUB
mkdir -p /boot/grub
grub-mkconfig -o /boot/grub/grub.cfg
grub-install --target=i386-pc "$DISK"

# Disable root password login
passwd -d root
passwd -l root

# Add automation user
useradd \
  --comment 'User for automatic provisioning' \
  --password "$(openssl passwd -6 'please_change_me_i_am_not_safe')" \
  --user-group \
  --create-home \
  automation

# Make automation user a sudoer
echo 'automation ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/automation
chmod u=r,g=r,o= /etc/sudoers.d/automation

# Ensure required services are enabled
systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service
systemctl enable sshd.service
systemctl enable qemu-guest-agent.service
systemctl enable cloud-init-local.service
systemctl enable cloud-init.service
systemctl enable cloud-final.service

# Update pacman keys
pacman-key --init
pacman-key --populate archlinux

# Initial cloud-init configuration
cloud-init init --local
