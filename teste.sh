#!/usr/bin/env bash

latest_version()
{
  echo "1.0.0"
}

update_repository()
{
  sudo apt-get -y update
  sudo apt-get install vim -y
}

resolution()
{
  sudo xrandr -s 800x600
  sudo xset -dpms
  sudo xset s off
}

create_dir()
{
  if [ ! -d "/vr/" ]; then
    mkdir /vr/
  fi

  if [ ! -d "/pdv/exec" ]; then
    mkdir /pdv/exec
  fi

  if [ ! -d "/pdv_vr" ]; then
    mkdir /pdv_vr/
  fi

  sudo chmod -R 2777 /vr/
  sudo chmod -R 2777 /pdv/
  sudo chmod -R 2777 /home/$USER/
}

mount_server()
{
  IP=$(whiptail --inputbox "Digite o IP do Servidor" 8 78 --title "Instalação VRPdv Linux" 3>&1 1>&2 2>&3)
  sudo chmod +777 /etc/fstab
  echo //$IP/vr /pdv_vr/ cifs username=pdv,password=pdv 0 0 >> /etc/fstab
  sudo mount //$IP/vr /pdv_vr/ -o username=pdv,password=pdv
}

copy_files()
{
  echo "Copying libs..."
  sudo cp -r /pdv_vr/exec/lib/ /pdv/exec/
  echo "Copying database..."
  sudo cp -r /pdv_vr/pdv/database/VR.FDB /pdv/database/
  sudo chmod g+w /pdv/database/VR.FDB
}



#main script

latest_version
mount_server
create_dir
copy_files
