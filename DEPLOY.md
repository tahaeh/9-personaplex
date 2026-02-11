# Deploy PersonaPlex

## Fly.io (Recommended)

Deploy PersonaPlex to [Fly.io](https://fly.io) with GPU acceleration. No AWS vCPU limits, simple CLI workflow.

### Prerequisites

- [Fly CLI](https://fly.io/docs/flyctl/install/) installed (`brew install flyctl` on Mac)
- Fly.io account (`fly auth signup`)
- HuggingFace token with access to [nvidia/personaplex-7b-v1](https://huggingface.co/nvidia/personaplex-7b-v1)

### Deploy in 4 commands

```bash
# 1. Clone the repo
git clone https://github.com/tahaeh/9-personaplex.git && cd 9-personaplex

# 2. Create the app on Fly
fly apps create personaplex

# 3. Set your HuggingFace token as a secret
fly secrets set HF_TOKEN=hf_your_token_here

# 4. Deploy (builds Docker image + launches GPU machine)
fly deploy
```

First deploy takes ~15 minutes (model download). After that, the app is live at:

**https://personaplex.fly.dev**

### Configuration

Edit `fly.toml` to change:

- **GPU type**: `vm.size` — options: `a100-40gb` (~$2.50/hr), `l40s` (~$1.25/hr), `a100-80gb` (~$3.50/hr)
- **Region**: `primary_region` — use `ord` (Chicago) for most GPU types
- **Auto-stop**: machines auto-stop when idle to save money

### Useful commands

```bash
fly logs              # View server logs
fly status            # Check app status
fly ssh console       # SSH into the machine
fly machine stop      # Stop to save costs
fly machine start     # Start back up
fly destroy           # Tear down everything
```

### Cost

GPU machines are billed per second. With auto-stop enabled, you only pay while the machine is running.

| GPU         | Price/hr | VRAM  |
|-------------|----------|-------|
| L40S        | ~$1.25   | 48 GB |
| A100 40GB   | ~$2.50   | 40 GB |
| A100 80GB   | ~$3.50   | 80 GB |

---

## Local (No Cloud)

Run PersonaPlex on your own machine. Works on Mac, Linux, or Windows (WSL).

### Prerequisites

- Python 3.10–3.12
- [Opus codec](https://github.com/xiph/opus): `brew install opus` (Mac) or `sudo apt install libopus-dev` (Linux)
- ~20 GB disk space (for model download)
- 16+ GB RAM

### Setup

```bash
# Clone
git clone https://github.com/tahaeh/9-personaplex.git && cd 9-personaplex

# Create venv and install
pip install uv
uv venv .venv --python 3.12
source .venv/bin/activate
uv pip install moshi/.

# Set your HuggingFace token
cp .env.example .env
# Edit .env and add your HF_TOKEN

# Run (CPU mode for Mac / no GPU)
source .env
SSL_DIR=$(mktemp -d); python -m moshi.server --ssl "$SSL_DIR" --device cpu

# Run (with NVIDIA GPU)
source .env
SSL_DIR=$(mktemp -d); python -m moshi.server --ssl "$SSL_DIR"
```

Open **https://localhost:8998** in your browser.

> Note: CPU mode works but is slow (~10 min to load, noticeable latency). GPU is recommended for real-time conversation.

---

## Docker Compose (EC2 or any GPU server)

For AWS EC2, RunPod, or any server with Docker + NVIDIA GPU:

```bash
git clone https://github.com/tahaeh/9-personaplex.git && cd 9-personaplex
cp .env.example .env
# Edit .env with your HF_TOKEN
docker compose up -d
```

Open **https://\<server-ip\>:8998** in your browser.
