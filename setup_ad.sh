nmtui
dnf update -y
mkdir -p ~/.ssh/
chmod -R 600 ~/.ssh
cp -r /media/cdrom0/id_rsa  ~/.ssh/id_rsa
chmod -R 600 ~/.ssh/id_rsa
ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa anon@nfs-01.jamesonjendreas.com exit
dnf install -y nfs-utils samba-common-tools realmd oddjob oddjob-mkhomedir sssd adcli krb5-workstation
ipv4=$(ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)
hostshrt=$(/bin/hostname -s)
echo $ipv4 $hostshrt.jamesonjendreas.com  $hostshrt >> /etc/hosts
scp -i ~/.ssh/id_rsa anon@nfs-01.jamesonjendreas.com:/srv/nfs-01/configs/smb.conf /etc/samba/smb.conf
scp -i ~/.ssh/id_rsa anon@nfs-01.jamesonjendreas.com:/srv/nfs-01/configs/krb5.conf /etc/krb5.conf
scp -i ~/.ssh/id_rsa anon@nfs-01.jamesonjendreas.com:/srv/nfs-01/configs/sudoers /etc/sudoers
scp -i ~/.ssh/id_rsa anon@nfs-01.jamesonjendreas.com:/srv/nfs-01/configs/sssd.conf /etc/sssd/sssd.conf
systemctl enable sssd
systemctl start sssd   
kinit jadmin
net ads join -k
authselect select sssd

