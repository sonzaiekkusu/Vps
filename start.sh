#!/bin/bash
set -e

echo "==========================================="
echo "  Railway SSH VPS"
echo "==========================================="

# Setup user/root, lalu exec sshd -D di foreground
exec /app/ssh-user-config.sh
