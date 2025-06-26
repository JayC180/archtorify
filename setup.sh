#!/usr/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script needs to be run with sudo"
   exec sudo "$0" "$@"
   exit 1
fi

if ! pacman -Q tor &> /dev/null; then
    echo "installing tor"
    pacman -S --noconfirm tor
fi

# dns stuff
systemctl stop systemd-resolved.service
systemctl disable systemd-resolved.service

if ! pacman -Q dnsmasq &> /dev/null; then
    echo "installing dnsmasq"
    pacman -S --noconfirm dnsmasq
fi

cat > "/etc/dnsmasq-tor.conf" <<EOF
no-resolv
server=127.0.0.1#9053
listen-address=127.0.0.1
EOF

cat > "/etc/dnsmasq-clearnet.conf" <<EOF
no-resolv
server=8.8.8.8
server=1.1.1.1
listen-address=127.0.0.1
EOF

