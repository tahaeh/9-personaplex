#!/bin/bash
# Run this on an Ubuntu 22.04 EC2 instance with GPU (g5.xlarge, g4dn.xlarge, etc.)
# Use an AMI with NVIDIA drivers pre-installed (e.g. "NVIDIA GPU-Optimized" or "Deep Learning" AMI)
# Usage: curl -sSL https://raw.githubusercontent.com/tahaeh/9-personaplex/main/deploy/ec2-setup.sh | bash
# Or: scp deploy/ec2-setup.sh ubuntu@<ec2-ip>:~ && ssh ubuntu@<ec2-ip> 'bash ec2-setup.sh'

set -e

echo "==> Installing Docker..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER

echo "==> Installing NVIDIA Container Toolkit..."
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

echo ""
echo "==> Done! Log out and back in (or run 'newgrp docker') so docker works without sudo."
echo "==> Then run these steps:"
echo "  1. Clone: git clone https://github.com/tahaeh/9-personaplex.git && cd 9-personaplex"
echo "  2. Create .env with your HF_TOKEN (see .env.example)"
echo "  3. Run: docker compose up -d"
echo "  4. Open https://<YOUR_EC2_PUBLIC_IP>:8998 in your browser"
echo "  5. Accept the security group: ensure TCP port 8998 is open"
