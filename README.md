# Setup a local LLM on Linux
## Prerequisites
Install the followng tools either by following the official documentation or by running the `prereqs.sh`.
- [UV](https://docs.astral.sh/uv/getting-started/installation/)
- [Docker](https://docs.docker.com/engine/install/)
- [Nvidia Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) and configure Docker

## Services
- [Open WebUI](https://github.com/open-webui/open-webui)
- [Apache Tika](https://tika.apache.org/)
- [Postgresql](https://www.postgresql.org/)
- LLM Providers:
  - [Ollama](https://ollama.com/) (Being used)
  - [vLLM](https://docs.vllm.ai/en/latest/) (Not being used yet)

## Hardware
- If you're using Ollama, check [hardware support](https://docs.ollama.com/gpu).
- If your're using vLLM, check the [hardware requirements](https://docs.vllm.ai/en/latest/getting_started/installation/gpu/).

## Setup
### Run all services
```
docker compose pull
docker compose up -d
```
Open `http://localhost:3000` in your browser to start exploring the WebUI.

### Install [Continue](https://docs.openwebui.com/tutorials/integrations/dev-tools/continue-dev) VS Code Extension

