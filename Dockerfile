FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install SSH server + tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server \
    sudo \
    procps \
    passwd \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/run/sshd

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
