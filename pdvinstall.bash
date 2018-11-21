#!/bin/bash

# Iniciando a instalacao do VR Pdv
echo 'Iniciando a instalacao do VR PDV Aguarde....'

#Removendo Instalador Padrão
#sudo rm -rf /pdvinstall.bash

sudo apt-get -y update

#Instalando Vim
sudo apt-get install vim -y

#Gravando a Resolução Padrão VR
sudo xrandr -s 800x600

sudo xset -dpms

sudo xset s off

sudo chmod +777 /etc/fstab

#Criando as Pastas
sudo mkdir /vr/
sudo mkdir /pdv/
sudo mkdir /pdv_vr/
sudo mkdir /SAT/
sudo mkdir /pdv/sat
sudo mkdir /pdv/driver

sudo chmod -R 2777 /vr/
sudo chmod -R 2777 /pdv/
sudo chmod -R 2777 /home/$USER/

echo "Digite o IP do servidor da pasta vr"

#read IP_DO_SERVIDOR

echo //192.168.88.44/vr /pdv_vr/ cifs username=pdv,password=pdv 0 0 >> /etc/fstab

sudo mount //$IP_DO_SERVIDOR/vr /pdv_vr/ -o username=pdv,password=pdv

#Copiando Arquivos do PDV
sudo cp -r /pdv_vr/pdv/* /pdv/
sudo chmod g+w /pdv/database/VR.FDB

#sudo cp -r /pdv/VrPdv.desktop /home/$USER/Área\ de\ Trabalho/
#sudo cp -r /pdv/VrPdv.desktop /home/$USER/Desktop

wget https://raw.githubusercontent.com/david27alves/vrpdv/master/lib/VRPdv.desktop /home/$USER/Área\ de\ Trabalho/
wget https://raw.githubusercontent.com/david27alves/vrpdv/master/lib/VRPdv.desktop /home/$USER/Desktop

#Copiando properties do servidor
sudo cp -r /pdv_vr/vr.properties /vr/vr.properties

#Copiando Arquivos do Sitef
sudo cp -r /pdv/sitef/CliSiTef.ini /home/$USER
chmod 444 /home/$USER/CliSiTef.ini

sudo cp -r /pdv/sitef/lib/* /usr/lib/

#Copiando bibliotecas diversos
sudo cp -r /pdv_vr/pdv/lib/ /usr/lib

#Baixando ECF Teste
cd /pdv/util/
sudo wget https://github.com/david27alves/vrpdv/blob/master/lib/ecf.tar.bz2?raw=true
sudo tar -jxvf ecf.tar.bz2
sudo chmod -R 2777 ecf

#Adicionando usuários nos grupos
sudo adduser $USER lp
sudo adduser $USER dialout
sudo chown -R $USER:firebird /vr
sudo chown -R $USER:firebird /pdv
sudo chown -R $USER:firebird /dev/tty*
sudo gpasswd -a $USER firebird
sudo chown -R $USER:firebird /home/$USER
sudo chmod g+w /home/$USER
sudo chmod u+s /usr/bin/java
sudo sh -c 'echo "greeter-setup-script=/usr/bin/numlockx on" >> /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf'

java -jar /pdv/exec/VRPdv.jar
