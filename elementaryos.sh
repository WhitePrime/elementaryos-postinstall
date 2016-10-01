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
    sudo apt install -y prelink
	sudo sed -i 's|^PRELINKING=unknown|PRELINKING=yes|' /etc/default/prelink
	sudo sed -i 's|^PRELINK_OPTS=-mR|PRELINK_OPTS=-amR|' /etc/default/prelink
	echo 'dpkg::Post-Invoke {"echo Executando prelink ...;/etc/cron.daily/prelink";}' | sudo tee /etc/apt/apt.conf.d/98prelink
	sudo prelink -amvR
    
#07 - Alguns Tunning
    sudo echo 'vm.vfs_cache_pressure = 500' >> /etc/sysctl.conf
	sudo echo 'vm.dirty_background_ratio = 5' >> /etc/sysctl.conf
	sudo echo 'vm.dirty_ratio = 25' >> /etc/sysctl.conf
	sudo echo 'vm.swappiness = 10' >> /etc/sysctl.conf
	sudo echo 'vm.page-cluster = 4' >> /etc/sysctl.conf
	sudo sed -i s/NoDisplay=true/NoDisplay=false/g /etc/xdg/autostart/*.desktop
    
