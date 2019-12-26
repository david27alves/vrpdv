#!/bin/bash

# Iniciando a instalacao do VR Pdv
echo 'Iniciando a instalacao do VR PDV Aguarde....'

#Removendo Instalador Padrão
sudo rm -rf /pdvinstall.bash

#Gravando a Resolução Padrão VR
sudo xrandr -s 800x600 -r 60.00

#Setando DNS
sudo echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf

#Criando Rota Martins
#sudo route add -net 172.19.0.0 netmask 255.255.0.0 gw 192.168.5.252

sudo xset -dpms
sudo xset s off

sudo chmod +777 /etc/fstab

#Criando as Pastas
sudo mkdir /vr/

sudo chmod -R 2777 /vr/
sudo chmod -R 2777 /pdv/
sudo chmod -R 2777 /home/$USER/

echo "Digite o IP do servidor da pasta vr"

read IP_DO_SERVIDOR

echo //$IP_DO_SERVIDOR/vr /pdv_vr/ cifs username=pdv,password=pdv 0 0 >> /etc/fstab

sudo mount //$IP_DO_SERVIDOR/vr /pdv_vr/ -o username=pdv,password=pdv

#Copiando Arquivos do PDV
sudo cp -r /pdv_vr/pdv/* /pdv/
sudo cp -r /pdv_vr/pdv/exec/VRPdv.jar /pdv/exec/
sudo cp -r /pdv_vr/pdv/exec/lib/* /pdv/exec/lib/
sudo cp -r /pdv_vr/vr.properties /vr/

sudo chmod g+w /pdv/database/VR.FDB

sudo cp -r /pdv/VRPdv.desktop /home/$USER/Área\ de\ Trabalho/
sudo cp -r /pdv/VRPdv.desktop /home/$USER/Desktop

#Copiando Arquivos do Sitef
sudo cp -r /pdv/sitef/* /usr/lib/
sudo rm -rf /usr/lib/libclisitef32.so

sudo chmod 444 /usr/lib/CliSiTef.ini

sudo chmod 777 /usr/lib/libclisitef.so
sudo chmod 777 /usr/lib/libemv.so
sudo chmod 777 /usr/lib/rechargeRPC.so
sudo chmod 777 /usr/lib/libseppemv.so

#Copiando bibliotecas diversos
sudo cp -r /pdv_vr/pdv/lib/ /usr/lib

#Baixando Rules Atualizado
sudo apt-get install wget -s
cd /home/$USER/
sudo wget https://api.pulpo.work/api/v2/files/xPWumuXwyNRwD43yK/52b1630e-6e97-4416-98c4-da13245c3b34
mv /home/$USER/VRRULES /etc/udev/rules.d/vr.rules

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

#Iniciar com num lock ativo
sudo sh -c 'echo "greeter-setup-script=/usr/bin/numlockx on" >> /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf'

#Definir senha padrão no anydesk
echo "vr123456" > anydesk_password
cat anydesk_password | anydesk --set-password
rm anydesk_password
anydesk_ID="$(anydesk --get-id)"
echo "ID do AnyDesk: $anydesk_ID" > /pdv/Any_$USER.txt

sudo init 6
