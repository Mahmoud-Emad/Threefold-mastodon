FROM ubuntu:20.04

ENV SSH_KEY="Test ssh key" LOCAL_DOMAIN=Test.com SMTP_SERVER=smtp.mailgun.org SMTP_PORT=587 \
    SMTP_AUTH_METHOD=plain
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" |  tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive TZ=Europe/Belgium apt-get install -y docker-ce docker-ce-cli containerd.io openssh-server sudo ufw && \
    rm -rf /var/lib/apt/lists/*

RUN curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

RUN wget -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.5/zinit && \
  chmod +x /sbin/zinit 

COPY ./scripts/ /scripts/
COPY ./zinit/ /etc/zinit/
COPY ./docker /docker/
RUN chmod +x /scripts/*.sh

ENTRYPOINT  ["zinit", "init"]