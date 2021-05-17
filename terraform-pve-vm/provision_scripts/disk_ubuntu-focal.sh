#!/bin/bash

set -ex

disk="/dev/sda"
part="4"
volume_group="ubuntu-vg"
logical_volume_path="/dev/ubuntu-vg/ubuntu-lv"

free_space="$(parted --script "$disk" unit GB print free | sed -rn 's/.*\s+([0-9.]+)GB\s+Free Space/\1/p' | tac | head -n 1)"
enough_free_space="$(echo "$free_space > 1.0" | bc)"

sgdisk --move-second-header "$disk"

if [ $enough_free_space -eq 1 ];
then
  sgdisk --largest-new="$part" "$disk"
  partprobe -s
  pvcreate "${disk}${part}"

  vgextend "$volume_group" "${disk}${part}"
  lvextend --extents +100%FREE --resize-fs "$logical_volume_path"
fi
