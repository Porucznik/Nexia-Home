#!/usr/bin/env ruby
# Domyślna tabulacja dokumentu - 4 spacje

    puts "Witamy w instalatorze systemu Nexia"
    puts "Uwaga! Prosze zachowac ostroznosc, w szczegolnosci podczas montowania"\
         " partycji!"
    # Ustawienia wyswietlania w powłoce tekstowej terminala
    system "loadkeys pl"
    system "setfont Lat2-Terminus16"
    system "export LANG=pl_PL.UTF-8"
    puts ""
    puts ""

    # Wyświetlenie układu partycji
    system "lsblk"
    puts ""
    puts ""

    # Poproszenie użytkownika o podanie partycji do zamontowania 
    # podczas instalacji
    puts "Prosze wybrac partycje, ktora ma zostac uzyta jako glowna:"
    $PartycjaRoot = gets.chomp!
    system "mount /dev/#{$PartycjaRoot} /mnt"
    puts ""
    puts ""

    puts "Czy chcesz utworzyc partycje swap ? (t/n)"
    $SwapWybor = gets.chomp!
    if $SwapWybor == "t"
        puts "Prosze wybrac partycje, ktora ma zostac uzyta jako swap:"
        $PartycjaSwap = gets.chomp!
        system "swapon /dev/#{$PartycjaSwap}"
    elsif $SwapWybor == "n"
    end
    puts ""
    puts ""

    puts "Czy chcesz utworzyc partycje home ? (t/n)"
    $HomeWybor = gets.chomp!
    if $HomeWybor == "t"
        puts "Prosze wybrac partycje, ktora ma zostac uzyta jako home:"
        $PartycjaHome = gets.chomp!
        system "mkdir /mnt/home"
        system "mount /dev/#{$PartycjaHome} /mnt/home"
    elsif $HomeWybor == "n"
    end
    puts ""
    puts ""

    # Rozpoczęcie instalacji podstawowych składnikow systemu oraz 
    # generowanie pliku fstab
    puts "Czy rozpoczac instalacje podstawowych skladnikow systemu ?(t/n)"
    i = gets.chomp!
    if i == "t"
        system "pacstrap -i /mnt base ruby --noconfirm"
        system "genfstab -U -p /mnt >> /mnt/etc/fstab"
        puts ""
        puts ""

        # Kopiowanie plikow konfiguracyjnych od Nexi do konfiguracji
        # nowego systemu lub katalogów tymczasowych
        puts "Prosze czekac, trwa kopiowanie plikow"
        system "cp /etc/locale.conf /mnt/etc"
        system "cp /etc/locale.gen /mnt/etc"
        system "cp /etc/vconsole.conf /mnt/etc"
        system "cp /etc/skel/.bash_profile /mnt/etc/skel"
        system "cp /etc/skel/.xinitrc /mnt/home"
        system "cp /etc/skel/.xsession /mnt/etc/skel"
        system "mkdir /mnt/etc/skel/.config"
        system "mkdir /mnt/etc/skel/.config/dconf"
        system "mkdir /mnt/etc/skel/.config/autostart"
        system "cp /etc/skel/.config/autostart/conky.desktop"\
               " /mnt/etc/skel/.config/autostart"
        system "cp /etc/skel/.config/dconf/user /mnt/etc/skel/.config/dconf"
        system "cp -R /etc/skel/.cinnamon /mnt/etc/skel"
        system "cp /etc/skel/.logo_full.png /mnt/etc/skel/"
        system "cp /etc/skel/.logox2.png /mnt/etc/"
        system "cp /etc/xdg/user-dirs.conf /mnt/etc/xdg"
        system "cp /etc/xdg/user-dirs.defaults /mnt/etc/xdg"
        system "cp -R /usr/share/icons/NITRUX /mnt/etc"
        system "cp -R /usr/share/icons/NITRUX-Buttons /mnt/etc"
        system "cp -R /usr/share/themes/Minty /mnt/etc"
        system "cp -R /etc/Skorki /mnt/etc"
        system "cp -R /etc/Czcionki /mnt/etc"
        system "mkdir /mnt/etc/systemd/system/getty@tty1.service.d"
        system "mkdir /mnt/usr/share/fonts"
        system "mkdir /mnt/usr/share/fonts/TTF"
        system "cp /usr/share/fonts/TTF/Dragon.ttf /mnt/usr/share/fonts/TTF"
        system "cp /usr/share/fonts/TTF/fonts.dir /mnt/usr/share/fonts/TTF"
        system "cp /usr/share/fonts/TTF/fonts.scale /mnt/usr/share/fonts/TTF"
        system "cp -R /usr/share/backgrounds /mnt/usr/share"
        system "cp /etc/lxdm.conf /mnt/home"
        system "cp -R /etc/nexia /mnt/etc"

    # Zostaje przekopiowania różna konfiguracja conkiego w zależności
    # czy istnieje osobna partycja home czy nie
    if $HomeWybor == "t"
        system "cp /etc/.conkyrc /mnt/etc/skel"
    elsif $HomeWybor == "n"
        system "cp /etc/skel/.conkyrc /mnt/etc/skel"
    end
    puts ""
    puts ""

    # Uruchomienie 2 cześci instalatora
    system "arch-chroot /mnt ruby /etc/nexia/Instalacja2.rb"
    elsif i =="n"
        puts "Do widzenia"
    end
