#!/bin/bash
cd "$(dirname "$0")"

# Load token from .env
if [ -f .env ]; then
  set -a
  source .env
  set +a
fi

if [ "$HF_TOKEN" = "your_token_here" ] || [ -z "$HF_TOKEN" ]; then
  echo "Please edit the .env file and paste your HuggingFace token."
  echo "Get it from: https://huggingface.co/settings/tokens"
  echo ""
  read -p "Press Enter to open .env in your editor..."
  open -e .env
  exit 1
fi

export HF_TOKEN
export PATH="$HOME/.local/bin:$PATH"

source .venv/bin/activate
SSL_DIR=$(mktemp -d)
echo "Starting PersonaPlex server..."
echo "Open https://localhost:8998 in your browser when ready."
echo ""
python -m moshi.server --ssl "$SSL_DIR"
