#!/bin/bash

#Paramètres
sftproot=/var/sftp # Directory where user chroot folders will be stored

function generate_user_vars() {
username="$1"
user_root="$sftproot/$username"
user_home="$user_root/home"
password=$(openssl rand -base64 12)
}

function check_env() {
# Check chroot env
if [ ! -d $sftproot ]; then
  mkdir $sftproot
  chown root:root $sftproot
fi
}

function user_background_check() {
# Check if user exist
if id "$username" &>/dev/null; then
  echo "User $username already exists. Task canceled."
  exit 1
fi

# Check if user exist in sshd_config
if grep -q "$username" "/etc/ssh/sshd_config"; then
  echo "User $username already exists in '/etc/ssh/sshd_config'. Task canceled."
  exit 1
fi

# Check if $user_root exist
if [ -d $user_root ]; then
  echo "Directory $user_root already exists. Task canceled."
  exit 1
fi
}

function create_user_env() {
# Create user
useradd "$username" -d "$user_home" -s /bin/false
# Set random password
echo "$username:$password" | chpasswd

# Create user dir and make ownership for chroot
mkdir -p "$user_home"
chown root:root "$user_root"
chown "$username:$username" "$user_home"

# Add user to sshd_config
cat <<EOF >> /etc/ssh/sshd_config
Match User $username
    X11Forwarding no
    AllowTcpForwarding no
    ChrootDirectory $user_root
    ForceCommand internal-sftp -d /home
EOF

echo "User $username was created."
echo "Password: $password"
}

# Check root permissions
if [ "$(id -u)" -ne 0 ]; then
  echo "This script mus be run as root"
  exit 1
fi

# Check if username given
if [ -z "$1" ]; then
  echo "Error: No user given as argument."
  echo "The proper syntaxe is:"
  echo "$0 USerName"
  exit 1
fi

generate_user_vars $1
check_env
user_background_check
create_user_env
systemctl restart sshd
