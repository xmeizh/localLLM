#!/usr/bin/env bash
set -e

sudo apt update && sudo apt install -y curl gnupg2

echo "== Prerequisite 1: Installing uv =="
curl -LsSf https://astral.sh/uv/install.sh | sh
echo 'eval "$(uv generate-shell-completion bash)"' >> ~/.bashrc

echo "== Prerequisite 2: Installing docker engine =="
# Add Docker's official GPG key:

sudo apt install ca-certificates
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Manage Docker as a non-root user..."
sudo groupadd docker 2>/dev/null || true
sudo usermod -aG docker $USER

echo "Configure Docker to start on boot with systemd..."
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
sudo systemctl restart docker

echo "== Prerequisite 3: Installing the NVIDIA Container Toolkit =="
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
&& curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

export NVIDIA_CONTAINER_TOOLKIT_VERSION=1.18.2-1
sudo apt-get update && sudo apt-get install -y \
nvidia-container-toolkit=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
nvidia-container-toolkit-base=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
libnvidia-container-tools=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
libnvidia-container1=${NVIDIA_CONTAINER_TOOLKIT_VERSION}

echo "Configuring Docker..."
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker