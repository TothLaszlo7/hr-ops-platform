FROM jenkins/inbound-agent:3355.v388858a_47b_33-19

USER root

RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    docker.io \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf aws awscliv2.zip

RUN curl -LO "https://dl.k8s.io/release/v1.31.0/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && rm kubectl

RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

USER jenkins