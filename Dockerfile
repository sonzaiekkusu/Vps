FROM archlinux:base

# Install SSH server + tools
RUN pacman -Sy --noconfirm && pacman -S --noconfirm --needed \
    openssh \
    sudo \
    procps-ng \
    shadow \
    ca-certificates \
    tzdata \
    && rm -rf /var/cache/pacman/pkg/* \
    && mkdir -p /var/run/sshd \
    && ssh-keygen -A \
    && ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# SSH config default (akan di-override oleh ssh-user-config.sh)
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

WORKDIR /app

COPY ssh-user-config.sh /app/ssh-user-config.sh
COPY start.sh /app/start.sh
RUN chmod +x /app/ssh-user-config.sh /app/start.sh

# SSH port 22 (butuh TCP Proxy di Railway)
EXPOSE 22

CMD ["/app/start.sh"]
