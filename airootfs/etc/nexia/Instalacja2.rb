#!/usr/bin/env ruby
# Domyślna tabulacja dokumentu - 4 spacje

    # Generowanie języka i czasu systemowego
    system "locale-gen"
    system "export LANG=pl_PL.UTF-8"
    system "loadkeys pl"
    system "setfont Lat2-Terminus16"
    system "ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime"
    system "hwclock --systohc --utc"

    # Pytanie o sieciową nazwe komputera
    puts "Prosze podac nazwe komputera:"
    $Hostname = gets.chomp!
    system "echo #{$Hostname} > /etc/hostname"
    puts ""
    puts ""

    # Pytanie o posiadana karte graficzną
    puts "Prosze wybrac sterownik pod posiadana karte graficzna:"\
         " (1 - Nvidia, 2 - Ati/Amd, 3 - Intel, 4 - Vesa, 5 - Virtualbox)"
    $VideoDriver = gets.chomp!
    puts ""
    puts ""

    # Tworzenie pustej zmiennej tekstowej do przechowywania dodatkowych
    # paczek wybranych przez użytkownika podczas instalacji
    $ListaPaczek = ""

    # Pytania dla użytkownika na temat dodatkowego oprogramowania do instalacji
    puts "Czy chcesz dodac menedzer logowania (t), lub ustawic autologowanie"\
         " dla utworzonego uzytkownika (n)?"
    $LoginManager = gets.chomp!
    if $LoginManager == "t"
        $ListaPaczek << "lxdm "
    end
    puts ""
    puts ""

    puts "Czy chcesz zainstalowac usprawnienie obslugi touchpada ? t/n"
    $TouchPad = gets.chomp!
    if $TouchPad == "t"
        $ListaPaczek << "xf86-input-synaptics "
    elsif $TouchPad == "n"
	    print "Zrezygnowano z instalacji programu."
    end
    puts ""
    puts ""

    puts "Czy chcesz zainstalowac pakiet biurowy Libre Office ? t/n"
    $OfficeSet = gets.chomp!
    if $OfficeSet == "t"
        $ListaPaczek << "libreoffice-fresh libreoffice-fresh-pl "
    elsif $OfficeSet == "n"
	    print "Zrezygnowano z instalacji programu."
    end
    puts ""
    puts ""

    #puts "Czy chcesz zainstalowac program Dropbox ? t/n"
    #$CloudDisk = gets.chomp!
    #if $CloudDisk == "t"
    #    $ListaPaczek << "dropbox "
    #elsif $CloudDisk == "n"
    #    print "Zrezygnowano z instalacji programu."
    #end
    #puts ""
    #puts ""

    puts "Czy chcesz zainstalowac graficzny menedzer pakietow ? t/n"
    $PackageSet = gets.chomp!
    if $PackageSet == "t"
        $ListaPaczek << "gnome-packagekit "
    elsif $PackageSet == "n"
        print "Zrezygnowano z instalacji programu."
    end
    puts ""
    puts ""

    puts "Czy chcesz zainstalowac odtwarzacz muzyki Audacious ? t/n"
    $MusicPlayer = gets.chomp!
    if $MusicPlayer == "t"
        $ListaPaczek << "audacious "
    elsif $MusicPlayer == "n"
        print "Zrezygnowano z instalacji programu."
    end
    puts ""
    puts ""

    puts "Czy chcesz zainstalowac odtwarzacz wideo VLC Player ? t/n"
    $VideoPlayer = gets.chomp!
    if $VideoPlayer == "t"
        $ListaPaczek << "vlc "
    elsif $VideoPlayer == "n"
        print "Zrezygnowano z instalacji programu."
    end
    puts ""
    puts ""

    puts "Czy chcesz zainstalowac komunikator Pidgin (Obsluga Gadu-gadu"\
        " i Facebook) ? t/n"
    $Communicator = gets.chomp!
    if $Communicator == "t"
        $ListaPaczek << "pidgin "
    elsif $Communicator == "n"
        print "Zrezygnowano z instalacji programu."
    end
    puts ""
    puts ""

    puts "Czy chcesz zainstalowac Steam ? t/n"
    $GamesPlatform = gets.chomp!
    if $GamesPlatform == "t"
        $ListaPaczek << "steam-native-runtime "
    elsif $GamesPlatform == "n"
        print "Zrezygnowano z instalacji programu."
    end
    puts ""
    puts ""

    #puts "Czy chcesz zainstalowac komunikator Skype ? t/n"
    #$VoiceChat = gets.chomp!
    #if $VoiceChat == "t"
    #    $ListaPaczek << "skype lib32-libpulse "
    #elsif $VoiceChat == "n"
    #    print "Zrezygnowano z instalacji programu."
    #end
    #puts ""
    #puts ""

    puts "Czy chcesz zainstalowac program Wine ? t/n"
    $Wine = gets.chomp!
    if $Wine == "t"
        $ListaPaczek << "wine wine-mono wine_gecko winetricks "
    elsif $Wine == "n"
        print "Zrezygnowano z instalacji programu."
    end
    puts ""
    puts ""

    puts "Czy chcesz zainstalowac program graficzny Gimp ? t/n"
    $RasterGraphicEditor = gets.chomp!
    if $RasterGraphicEditor == "t"
        $ListaPaczek << "gimp "
    elsif $RasterGraphicEditor == "n"
        print "Zrezygnowano z instalacji programu."
    end

    # Instalacja i konfiguracja bootloadera
    system "pacman -S grub-bios os-prober --noconfirm"
    system "rm /etc/default/grub"
    system "mv /etc/nexia/grub /etc/default"
    system "grub-install --recheck /dev/sda"
    system "cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo"\
           " /boot/grub/locale/en.mo"
    system "grub-mkconfig -o /boot/grub/grub.cfg"
    puts ""
    puts ""

    # If przemienający wcześniejszy wybór sterownika na konkretne paczki do instalacji
    if $VideoDriver == "1"
        system "pacman -S xf86-video-nouveau lib32-mesa --noconfirm"
    elsif $VideoDriver == "2"
        system "pacman -S xf86-video-ati lib32-mesa --noconfirm"
    elsif $VideoDriver == "3"
        system "pacman -S xf86-video-intel lib32-mesa --noconfirm"
    elsif $VideoDriver == "4"
        system "pacman -S xf86-video-vesa --noconfirm"
    elsif $VideoDriver == "5"
        system "pacman -S virtualbox-guest-utils virtualbox-guest-dkms --noconfirm"
    end

    # Dodanie repozytorium multilib (32 bit) i instalacja paczek - 
    # Podstawowych nexi i tych wybranych wcześniej przez użytkownika
    system "( echo [multilib] ;"\
           " echo Include = /etc/pacman.d/mirrorlist)"\
           " >> /etc/pacman.conf"
    system "pacman -Syy"
    system "pacman -S phonon-qt4-gstreamer phonon-qt5-gstreamer"\
           "  bash-completion xorg-server sudo networkmanager"\
           " xorg-xinit cinnamon cinnamon-control-center nemo"\
           " gnome-terminal ntfs-3g conky xdg-user-dirs chromium"\
           " pepper-flash  xterm alsa-utils gksu gedit p7zip wxgtk"\
           " shotwell gnome-system-monitor gnome-keyring base-devel"\
           " cinnamon-screensaver gnome-calculator evince gnome-screenshot"\
           " nemo-fileroller #{$ListaPaczek} --noconfirm"
    puts ""
    puts ""

    # Dodanie domyslnej konfiguracji mime
    system "printf '"\
           "\n[Default Applications]"\
           "\ninode/directory=nemo.desktop;"\
           "\napplication/pdf=evince.desktop;"\
           "\n' >> /usr/share/applications/mimeapps.list"

    # Tworzenie podstawowej konfiguracji startx
    system "mv /home/.xinitrc /etc/skel/.xinitrc"

    # Tworzenie normalnego konta użytkownika
    puts "Prosze podac nazwe uzytkownika(Bez duzych liter!):"
    $UserName = gets.chomp!
    system "useradd -m -G users,audio,lp,optical,storage,video,wheel,power"\
           " -s /bin/bash #{$UserName}"
    puts "Prosze podac haslo dla uzytkownika:"
    system "passwd #{$UserName}"
    puts ""
    puts ""

    # Nadanie hasła kontu root
    puts "Prosze podac haslo dla uzytkownika root:"
    system "passwd root"
    puts ""
    puts ""

    # Konfiguracja pliku /etc/sudoers
    system "sed -i 's/#\\\(\\\ %wheel\\\ ALL=(ALL)\\\ ALL\\\)/\\1/'"\
           " /etc/sudoers"

    # Konfiguracja programu sieciowego
    system "systemctl enable NetworkManager.service"
    system "systemctl disable dhcpcd.service"
    system "systemctl disable dhcpcd@.service"
    system "systemctl enable wpa_supplicant.service"
    system "gpasswd -a #{$UserName} network"

    # Kopiowanie pozostałej konfiguracji z folderów tymczasowych
    # na swoje ostateczne miejsce
    system "mv /etc/Minty /usr/share/themes"
    system "mv /etc/Czcionki/'Prime Light.otf' /usr/share/fonts/TTF"
    system "mv /etc/Czcionki/'Prime Regular.otf' /usr/share/fonts/TTF"
    system "rm -R /etc/Czcionki"
    system "mv /etc/Skorki/'Teal Blue + Black/' /usr/share/themes"
    system "rm -R /etc/Skorki"
    system "mv /etc/NITRUX /usr/share/icons"
    system "mv /etc/NITRUX-Buttons /usr/share/icons"

    # W zależności czy wybralismy menadzer logowania, czy nie 
    # nastepuje konfiguracja albo menadzera logowania, albo autologowania
    # i uruchamiania startx
    if $LoginManager == "t"
        system "rm /etc/lxdm/lxdm.conf"
        system "mv /home/lxdm.conf /etc/lxdm"
        system "systemctl enable lxdm"
    elsif $LoginManager == "n"
        system "( echo [Service] ; echo ExecStart= ;"\
               " echo ExecStart=-/sbin/agetty --autologin #{$UserName}"\
               " --noclear %I 38400 linux) >>"\
               " /etc/systemd/system/getty@tty1.service.d/autologin.conf"
        system "rm /home/lxdm.conf"
        system "rm /etc/nexia/lxbg.png"
    end
    puts ""
    puts ""

    # Koniec instalacji
    system "exit"
