#!/bin/bash

## GUIA PÓS INSTALAÇÃO LINUX ELEMENTARY ##

#01 - Ativar o Firewall
	sudo ufw default DENY
	sudo ufw enable
    
#02 - Mudar o nome do host (nome da máquina
	hostnamectl set-hostname --static 'elementaryOS'

#03 - Manter tudo atualizado
	sudo apt update
	sudo apt upgrade -y
	sudo apt update -y
	sudo apt dist-upgrade -y

#04 - Primeira limpeza
	sudo apt autoremove -y
	sudo apt install -f -y

#05 - Essenciais
	echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
	sudo apt install build-essential python-software-properties software-properties-common ttf-mscorefonts-installer ubuntu-restricted-addons ubuntu-restricted-extras -y

#06 - Preload
	sudo apt install -y preload
	sudo sed -i 's|^cycle *=.*|cycle = 25|' /etc/preload.conf
	sudo sed -i 's|^memfree *=.*|memfree = 60|' /etc/preload.conf
	sudo sed -i 's|^memcached *=.*|memcached = 15|' /etc/preload.conf
	sudo sed -i 's|^mapprefix *=.*|mapprefix = /usr/;/lib;/var/cache/;/opt/;!/|' /etc/preload.conf
	sudo sed -i 's|^exeprefix *=.*|exeprefix = !/usr/sbin/;!/usr/local/sbin/;/usr/;/opt/;!/|' /etc/preload.conf
	sudo /etc/init.d/preload restart

#07 - Prelink
	sudo apt install -y prelink
	sudo sed -i 's|^PRELINKING=unknown|PRELINKING=yes|' /etc/default/prelink
	sudo sed -i 's|^PRELINK_OPTS=-mR|PRELINK_OPTS=-amR|' /etc/default/prelink
	echo 'dpkg::Post-Invoke {"echo Executando prelink ...;/etc/cron.daily/prelink";}' | sudo tee /etc/apt/apt.conf.d/98prelink
	sudo prelink -amvR
    
#08 - Alguns Tunning
	sudo echo 'vm.vfs_cache_pressure = 500' >> /etc/sysctl.conf
	sudo echo 'vm.dirty_background_ratio = 5' >> /etc/sysctl.conf
	sudo echo 'vm.dirty_ratio = 25' >> /etc/sysctl.conf
	sudo echo 'vm.swappiness = 10' >> /etc/sysctl.conf
	sudo echo 'vm.page-cluster = 4' >> /etc/sysctl.conf
	sudo sed -i s/NoDisplay=true/NoDisplay=false/g /etc/xdg/autostart/*.desktop

## 09 - Reiniciar o computador após estas últimas instalações ##

#10 - Limpeza do sistema
	sudo apt clean -y
	sudo apt autoclean -y
	sudo apt autoremove -y
	sudo apt install -fy

#11 - Adicionando repositórios (Desmarque aqueles que julgar necessário)
	sudo add-apt-repository -y 'ppa:atareao/atareao'
	sudo add-apt-repository -y 'ppa:brightbox/ruby-ng'
	#sudo add-apt-repository -y 'ppa:gnome-shell-extensions'
	#sudo add-apt-repository -y 'ppa:graphics-drivers/ppa'
	sudo add-apt-repository -y 'ppa:n-muench/programs-ppa'
	sudo add-apt-repository -y 'ppa:nilarimogard/webupd8' # Albert e NetSpeed Indicator
	sudo add-apt-repository -y 'ppa:noobslab/apps'
	sudo add-apt-repository -y 'ppa:noobslab/icons'
	sudo add-apt-repository -y 'ppa:noobslab/macbuntu' # Temas Mac Like
	sudo add-apt-repository -y 'ppa:noobslab/themes'
	sudo add-apt-repository -y 'ppa:numix/ppa' # Numix Temas, Ícones e Outros

#12 - Instalar bibliotecas e dependências
	# alguns pacotes estão desatualizados ou não servem
	sudo apt install -y bridge-utils gir1.2-granite-1 gtk2-engines-pixbuf ipxe-qemu jbig2dec jbigkit-bin kdelibs-bin kdelibs5-data kdelibs5-plugins latexmk libaio1 libavcodec-extra libboost-random1.58.0 libcacard0 libcurl3 libcurl4-openssl-dev libfdt1 libfilezilla0 libgeos-dev libgranite-common libgranite2 libiodbc2 libiodbc2-dev libiscsi2 libjbig-dev libjbig0 libjbig2dec0 libjbig2dec0-dev libjpeg8-dev libnss3-tools libopenal-dev libpng12-dev libqt4-declarative libqt4-network libqt4-opengl libqtgui4 librados2 librbd1 libspice-server1 libusbredirparser1 libvirt-bin libx11-dev libxen-4.6 libxenstore3.0 libxft-dev mesa-utils qemu-block-extra qemu-system-common qemu-system-x86 seabios

#13 - Instalar Codecs
	sudo apt install -y ffmpeg lame libdvdread4 libavcodec-extra
	
#14 - Instalar compiladores
	sudo apt install -y bwbasic codeblocks clang cmake make cpp cppcheck g++ "g++-multilib" gcc "gcc-multilib" colorgcc gperf python gfortran gfortran-doc ratfor fpc fpc-source ruby ruby-dev
	ln -s /usr/bin/colorgcc /usr/local/sbin/g++
	ln -s /usr/bin/colorgcc /usr/local/sbin/gcc
