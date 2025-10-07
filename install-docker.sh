#!/bin/bash

# Espera até que o lock do APT seja liberado
while sudo fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
    echo "Aguardando a liberação do lock do APT..."
    sleep 5
done

# Instala dependências necessárias
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# ------------------------------
# Instalação do Docker
# ------------------------------

# Adiciona a chave GPG oficial do Docker
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Adiciona o repositório do Docker ao APT
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Atualiza pacotes e instala o Docker Engine e Docker Compose
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Adiciona o usuário atual ao grupo docker
sudo usermod -aG docker $USER

# ------------------------------
# Instalação do Cloudflared
# ------------------------------

# Baixa e instala o pacote oficial Cloudflared
CLOUDFLARED_VERSION=$(curl -s https://api.github.com/repos/cloudflare/cloudflared/releases/latest | grep tag_name | cut -d '"' -f 4)
echo "📦 Instalando Cloudflared versão $CLOUDFLARED_VERSION"

curl -L "https://github.com/cloudflare/cloudflared/releases/download/${CLOUDFLARED_VERSION}/cloudflared-linux-amd64.deb" -o cloudflared.deb
sudo dpkg -i cloudflared.deb
rm -f cloudflared.deb

# ------------------------------
# Testes de instalação
# ------------------------------
newgrp docker <<EONG
echo "✅ Docker instalado com sucesso!"
docker --version
docker compose version
EONG

echo "✅ Cloudflared instalado com sucesso!"
cloudflared --version
