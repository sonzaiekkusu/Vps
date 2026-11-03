#!/bin/bash
set -e

# ============== DEFAULT CREDENTIALS ==============
# Root only — langsung pakai tanpa set variable apapun
: ${ROOT_PASSWORD:="sonzaiekkusu"}
: ${AUTHORIZED_KEYS:=""}

echo ">>> SSH setup: root only"

# Pastikan config sshd: root login & password auth
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Set root password
if [ -n "$ROOT_PASSWORD" ]; then
    echo "root:$ROOT_PASSWORD" | chpasswd
    echo ">>> Root password set"
fi

# Authorized keys (opsional, langsung ke root)
if [ -n "$AUTHORIZED_KEYS" ]; then
    mkdir -p /root/.ssh
    echo "$AUTHORIZED_KEYS" > /root/.ssh/authorized_keys
    chmod 700 /root/.ssh
    chmod 600 /root/.ssh/authorized_keys
    echo ">>> Authorized keys di-set untuk root"
fi

echo ">>> Starting SSH server..."
exec /usr/sbin/sshd -D -e
