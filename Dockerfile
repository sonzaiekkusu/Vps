FROM nousresearch/hermes-agent:v2026.8.3@sha256:16788311e2fa3035456bdc1bafb8ec2b1777db64ebf020af9bb7eb73c3712c9e

# SSH server untuk akses VPS (base image = Debian 13, apt)
RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server \
    sudo \
    procps \
    passwd \
    ca-certificates \
    tzdata \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/run/sshd \
    && ssh-keygen -A \
    && ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# SSH config default (akan di-override oleh ssh-user-config.sh)
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Data Hermes persisten — attach Railway Volume ke /data
ENV HERMES_HOME=/data/.hermes \
    HERMES_WRITE_SAFE_ROOT=/data/.hermes \
    HERMES_LAZY_INSTALL_TARGET=/data/.hermes/lazy-packages \
    HERMES_DASHBOARD=1 \
    HERMES_DASHBOARD_HOST=0.0.0.0 \
    HERMES_GATEWAY_BOOTSTRAP_STATE=running

WORKDIR /app

COPY ssh-user-config.sh /app/ssh-user-config.sh
COPY start.sh /app/start.sh
RUN chmod +x /app/ssh-user-config.sh /app/start.sh

# SSH 22 (TCP Proxy) + Dashboard 8080 (HTTP domain)
EXPOSE 22 8080

ENTRYPOINT ["/app/start.sh"]
