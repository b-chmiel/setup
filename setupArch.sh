#!/bin/bash

## BEFORE CHROOT
loadkeys pl
timedatectl set-ntp true

# fdisk partition disks (swap, /, /boot, efi stuff) according to https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system#LUKS_on_a_partition

pacstrap /mnt base linux-lts linux-firmware gnome networkmanager grub neovim curl ffmpeg openssh-server valgrind openjdk-11-jre-headless htop which neofetch gnome-tweaks git firefox vlc net-tools qemu-kvm bridge-utils ncdu tree gnupg2 docker docker-compose zsh abcde exfat-fuse exfat-utils thunderbird python3-pip python3-virtualenv httpie

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt /bin/bash -e <<EOF
	ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
	hwclock --systohc
	echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
	locale-gen
	echo "KEYMAP=pl" >> /etc/vconsole.conf
	echo "Vostro-3578" >> /etc/hostname
	mkinitcpio -P
	useradd -m -g users -G wheel -s /usr/bin/zsh incvis
	systemctl enable NetworkManager
	systemctl enable gdm
EOF

## INSIDE CHROOT
#vim /etc/mkinitcpio.conf # set hooks
#mkinitcpio -P
#passwd
#grub-install --target=i386-pc /dev/vda
#grub-mkconfig -o /boot/grub/grub.cfg
#vim /etc/default/grub # set kernel parameters: cryptdevice=UUID=device-UUID:cryptroot root=/dev/mapper/cryptroot
#grub-mkconfig -o /boot/grub/grub.cfg
#grub-install --target=i386-pc /dev/vda
#mkinitcpio -P
#passwd incvis

#reboot
