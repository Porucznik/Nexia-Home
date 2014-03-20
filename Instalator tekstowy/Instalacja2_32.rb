#!/usr/bin/env ruby

system "locale-gen"
system "export LANG=pl_PL.UTF-8"
system "loadkeys pl"
system "setfont Lat2-Terminus16"
system "ln -s /usr/share/zoneinfo/Europe/Warsaw /etc/localtime"
system "hwclock --systohc --utc"
puts "Prosze podac nazwe komputera:"
h = gets.chomp!
system "echo #{h} > /etc/hostname"
puts "
"

puts "Prosze wybrac sterownik pod posiadana karte graficzna: (1 - Nvidia, 2 - Nvidia, modele starszej serii od 8000, 3 - Ati, 4 - Intel, 5 - Vesa, 6 - Virtualbox)"
d = gets.chomp!
puts "
"
all = ""
puts "Czy chcesz dodac menedzer logowania (t), lub ustawic autologowanie dla utworzonego uzytkownika (n)?"
us = gets.chomp!
if us == "t"
all << "lxdm "
end
puts "
"
puts "Czy chcesz zainstalowac usprawnienie obslugi touchpada ? t/n"
tp = gets.chomp!
if tp == "t"
all << "xf86-input-synaptics "
elsif tp == "n"
print "Zrezygnowano z instalacji programu."
end
puts "
"
puts "Czy chcesz zainstalowac pakiet biurowy Libre Office ? t/n"
lo = gets.chomp!
if lo == "t"
all << "libreoffice libreoffice-pl "
elsif lo == "n"
print "Zrezygnowano z instalacji programu."
end
puts "
"
puts "Czy chcesz zainstalowac program Dropbox ? t/n"
dbx = gets.chomp!
if dbx == "t"
all << "dropbox "
elsif dbx == "n"
print "Zrezygnowano z instalacji programu."
end
puts "
"
puts "Czy chcesz zainstalowac notyfikacje o aktualizacjach i menedzer pakietow ? t/n"
ya = gets.chomp!
if ya == "t"
all << "pyalpm-manjaro pamac-aur "
elsif ya == "n"
print "Zrezygnowano z instalacji programu."
end
puts "
"

puts "Czy chcesz zainstalowac odtwarzacz muzyki Audacious ? t/n"
pl = gets.chomp!
if pl == "t"
all << "audacious "
elsif pl == "n"
print "Zrezygnowano z instalacji programu."
end
puts "
"
puts "Czy chcesz zainstalowac odtwarzacz wideo VLC Player ? t/n"
plv = gets.chomp!
if plv == "t"
all << "vlc "
elsif plv == "n"
print "Zrezygnowano z instalacji programu."
end
puts "
"
puts "Czy chcesz zainstalowac komunikator Pidgin (Obsluga Gadu-gadu i Facebook) ? t/n"
ko = gets.chomp!
if ko == "t"
all << "pidgin "
elsif ko == "n"
print "Zrezygnowano z instalacji programu."
end
puts "
"
puts "Czy chcesz zainstalowac Steam ? t/n"
st = gets.chomp!
if st == "t"
all << "steam "
elsif st == "n"
print "Zrezygnowano z instalacji programu."
end
puts "
"
puts "Czy chcesz zainstalowac komunikator Skype ? t/n"
sk = gets.chomp!
if sk == "t"
all << "skype "
elsif sk == "n"
print "Zrezygnowano z instalacji programu."
end
puts "
"
puts "Czy chcesz zainstalowac program Wine ? t/n"
win = gets.chomp!
if win == "t"
all << "wine wine-mono wine_gecko "
elsif win == "n"
print "Zrezygnowano z instalacji programu."
end
puts "
"
puts "Czy chcesz zainstalowac program graficzny Gimp ? t/n"
kde = gets.chomp!
if kde == "t"
all << "gimp "
elsif kde == "n"
print "Zrezygnowano z instalacji programu."
end

system "pacman -S grub-bios os-prober --noconfirm"
system "rm /etc/default/grub"
system "mv /etc/nexia/grub /etc/default"
system "grub-install --recheck /dev/sda"
system "cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo"
system "grub-mkconfig -o /boot/grub/grub.cfg"
puts "
"

if d == "1"
system "pacman -S nvidia --noconfirm"
elsif d == "2"
system "pacman -S nvidia-304xx --noconfirm"
elsif d == "3"
system "pacman -S xf86-video-ati --noconfirm"
elsif d == "4"
system "pacman -S xf86-video-intel --noconfirm"
elsif d == "5"
system "pacman -S xf86-video-vesa --noconfirm"
elsif d == "6"
system "pacman -S virtualbox-guest-utils --noconfirm"
end

system "( echo [repo32] ; echo SigLevel = Never ; echo Server = https://dl.dropboxusercontent.com/u/44000136/Repo32/) >> /etc/pacman.conf"
system "pacman -Sy"
system "pacman -S xorg-server xorg-xinit cinnamon cinnamon-control-center nemo gnome-terminal ntfs-3g conky xdg-user-dirs chromium chromium-pepper-flash  xterm alsa-utils gksu gedit p7zip wxgtk shotwell gnome-system-monitor gnome-keyring base-devel cinnamon-screensaver gnome-calculator evince gnome-screenshot nemo-fileroller #{all} --noconfirm"
puts "
"

system "rm /etc/skel/.xinitrc"
system "mv /home/.xinitrc /etc/skel"

puts "Prosze podac nazwe uzytkownika(bez duzych liter!):"
u = gets.chomp!
system "useradd -m -G users,audio,lp,optical,storage,video,wheel,power -s /bin/bash #{u}"
system "passwd #{u}"
puts "
"
puts "Prosze podac haslo dla uzytkownika root:"
system "passwd root"
puts "
"
system "systemctl enable NetworkManager.service"
system "systemctl disable dhcpcd.service"
system "systemctl disable dhcpcd@.service"
system "systemctl enable wpa_supplicant.service"
system "gpasswd -a #{u} network"

system "mv /etc/Minty /usr/share/themes"
system "mv /etc/Czcionki/'Prime Light.otf' /usr/share/fonts/TTF"
system "mv /etc/Czcionki/'Prime Regular.otf' /usr/share/fonts/TTF"
system "rm -R /etc/Czcionki"
system "mv /etc/Skorki/'Teal Blue + Black/' /usr/share/themes"
system "rm -R /etc/Skorki"
system "mv /etc/NITRUX /usr/share/icons"
system "mv /etc/NITRUX-Buttons /usr/share/icons"
system "rm /etc/sudoers"
system "mv /home/sudoers /etc"
if us == "t"
system "rm /etc/lxdm/lxdm.conf"
system "mv /home/lxdm.conf /etc/lxdm"
system "systemctl enable lxdm"
elsif us == "n"
system "( echo [Service] ; echo ExecStart= ; echo ExecStart=-/sbin/agetty --autologin #{u} --noclear %I 38400 linux) >> /etc/systemd/system/getty@tty1.service.d/autologin.conf"
system "rm /home/lxdm.conf"
system "rm /etc/nexia/lxbg.png"
end
puts "
"
puts "Instalacja zakonczona! Prosze nacisnac enter aby zakonczyc."
wyjscie = gets.chomp!
system "exit"
