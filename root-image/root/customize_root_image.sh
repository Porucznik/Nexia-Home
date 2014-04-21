#!/bin/bash

set -e -u

sed -i 's/#\(pl_PL\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

usermod -s /bin/zsh root
cp -aT /etc/skel/ /root/

useradd -m -p "" -g users -G "users,lp,video,adm,audio,floppy,log,network,rfkill,scanner,storage,optical,power,wheel" -s /bin/zsh nexia

chown -R root:root /etc/sudoers.d/
chmod 750 /etc/sudoers.d
chmod 440 /etc/sudoers.d/g_wheel

sed -i 's/#\(\ %wheel\ ALL=(ALL)\ NOPASSWD:\ ALL\)/\1/' /etc/sudoers
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist

systemctl enable multi-user.target pacman-init.service
systemctl disable dhcpcd@
systemctl enable wpa_supplicant
systemctl enable NetworkManager
