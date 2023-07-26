# Samba setup

## Install dependencies

`yay -S samba`

## Create shared folders

```
sudo mkdir /srv/samba/{public,private}
sudo chmod 777 -R /srv/samba
sudo chown nobody:nobody -R /srv/samba
```

## Setup users

```
sudo useradd smbuser
sudo smbpasswd -a smbuser
```

## Setup samba

`/etc/samba/smb.conf`

```
[Public]
comment = public share
path = /srv/samba/public
browseable = yes
writable = yes
guest ok = yes

[Private]
comment = private share
path = /srv/samba/private
browseable = yes
guest ok = no
writable = yes
create mode = 0777
directory mode = 0777
valid users = smbuser
```

`sudo systemctl restart smb nmb`

## Open port in firewall

### Change wifi to home zone

`nmcli connection modify "<name of wifi>" connection.zone home`

### Open port via firewall-cmd

`sudo firewall-cmd --zone=home --add-service samba`