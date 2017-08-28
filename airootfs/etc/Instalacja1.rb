#!/usr/bin/env ruby

puts "Witamy w instalatorze systemu Nexia"
puts "Uwaga! Prosze zachowac ostroznosc, w szczegolnosci podczas montowania partycji!"
system "loadkeys pl"
system "setfont Lat2-Terminus16"
system "export LANG=pl_PL.UTF-8"
puts "
"
puts "Prosze wybrac wersje systemu do zainstalowania, 32 bitowa (32), czy 64 bitowa (64)?"
puts "Uwaga! Musi zostac wybrana ta sama wersja systemu, ktora jest uruchomiona na live."
ar = gets.chomp!
puts "
"
until ar == "32" || ar == "64"
puts "Prosze poprawnie wpisac wersje systemu!"
ar = gets.chomp!
end
puts "
"
system "lsblk"
puts "
"
puts "Prosze wybrac partycje, ktora ma zostac uzyta jako glowna:"
p = gets.chomp!
system "mount /dev/#{p} /mnt"
puts "
"
puts "Czy chcesz utworzyc partycje swap ? (t/n)"
sw = gets.chomp!
if sw == "t"
puts "Prosze wybrac partycje, ktora ma zostac uzyta jako swap:"
ps = gets.chomp!
system "swapon /dev/#{ps}"
elsif sw == "n"
end
puts "
"
puts "Czy chcesz utworzyc partycje home ? (t/n)"
ho = gets.chomp!
if ho == "t"
puts "Prosze wybrac partycje, ktora ma zostac uzyta jako home:"
ph = gets.chomp!
system "mkdir /mnt/home"
system "mount /dev/#{ph} /mnt/home"
elsif ho == "n"
end
puts "
"

puts "Czy rozpoczac instalacje podstawowych skladnikow systemu ?(t/n)"
i = gets.chomp!
if i == "t"
system "pacstrap -i /mnt base ruby --noconfirm"
system "genfstab -U -p /mnt >> /mnt/etc/fstab"
puts "
"
puts "Prosze czekac, trwa kopiowanie plikow"
system "cp /etc/locale.conf /mnt/etc"
system "cp /etc/locale.gen /mnt/etc"
system "cp /etc/vconsole.conf /mnt/etc"
system "cp /etc/skel/.bash_profile /mnt/etc/skel"

system "cp /etc/skel/.bashrc /mnt/etc/skel"
system "cp /etc/skel/.xinitrc /mnt/home"

system "cp -R /etc/skel/.config /mnt/etc/skel"
#system "mkdir /mnt/etc/skel/.config"

#system "mkdir /mnt/etc/skel/.config/autostart"

#system "cp /etc/sudoers /mnt/etc"
#system "cp /etc/skel/.logo_full.png /mnt/etc/skel/"
#system "cp /etc/skel/.logox2.png /mnt/etc/"
system "cp /etc/xdg/user-dirs.conf /mnt/etc/xdg"
system "cp /etc/xdg/user-dirs.defaults /mnt/etc/xdg"


#system "cp -R /etc/Skorki /mnt/etc"
#system "cp -R /etc/Czcionki /mnt/etc"
#system "mkdir /mnt/etc/systemd/system/getty@tty1.service.d"

#system "cp -R /usr/share/wallpapers /mnt/usr/share"
system "mkdir /mnt/usr/share/wallpapers"
system "cp /usr/share/wallpapers/tlobeta.png /mnt/usr/share/wallpapers"
system "cp /etc/sudoers /mnt/home"

system "cp /etc/lxdm.conf /mnt/home"
system "cp -R /etc/nexia /mnt/etc"
#if ho == "t"
#system "cp /etc/.conkyrc /mnt/etc/skel"
#elsif ho == "n"
#system "cp /etc/skel/.conkyrc /mnt/etc/skel"
#end
puts "
"
system "arch-chroot /mnt ruby /etc/nexia/Instalacja2_#{ar}.rb"
elsif i =="n"
puts "Do widzenia"
end
