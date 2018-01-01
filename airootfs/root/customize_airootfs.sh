#!/bin/bash

set -e -u

sed -i 's/#\(pl_PL\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

usermod -s /usr/bin/zsh root
cp -aT /etc/skel/ /root/
chmod 700 /root

useradd -m -p "" -g users -G "users,lp,video,adm,audio,floppy,log,network,rfkill,scanner,storage,optical,power,wheel" -s /bin/zsh nexia

#chown -R root:root /etc/sudoers.d/
#chmod 750 /etc/sudoers.d
#chmod 440 /etc/sudoers.d/g_wheel

sed -i 's/#\(\ %wheel\ ALL=(ALL)\ NOPASSWD:\ ALL\)/\1/' /etc/sudoers

sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

printf "
[Default Applications]
inode/directory=nemo.desktop
" >> /usr/share/applications/mimeapps.list


systemctl enable pacman-init.service choose-mirror.service
systemctl set-default multi-user.target

systemctl enable vboxservice.service
systemctl disable dhcpcd@
systemctl enable wpa_supplicant
systemctl enable NetworkManager
