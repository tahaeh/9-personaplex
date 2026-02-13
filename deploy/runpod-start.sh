#!/bin/bash
# RunPod startup script for PersonaPlex
# This runs inside a RunPod GPU Pod with PyTorch + CUDA pre-installed.
# It installs system deps, clones the repo, installs the moshi package, and starts the server.
#
# RunPod's proxy handles HTTPS/WSS, so no --ssl flag is needed.
# The app is accessible at: https://{POD_ID}-8998.proxy.runpod.net

set -e

echo "==> Installing system dependencies..."
apt-get update && apt-get install -y --no-install-recommends \
    libopus-dev \
    pkg-config \
    build-essential \
    git \
 && rm -rf /var/lib/apt/lists/*

echo "==> Installing uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"

echo "==> Cloning PersonaPlex..."
cd /workspace
if [ ! -d "personaplex" ]; then
    git clone https://github.com/tahaeh/9-personaplex.git personaplex
fi
cd personaplex

echo "==> Creating venv and installing moshi..."
uv venv .venv --python 3.12
uv pip install --python .venv/bin/python -e moshi/.

echo "==> Starting PersonaPlex server on port 8998..."
echo "==> Access at: https://${RUNPOD_POD_ID}-8998.proxy.runpod.net"
export PATH="/workspace/personaplex/.venv/bin:$PATH"
exec python -m moshi.server
