# Use Python 3.11 as the base image
FROM python:3.11-slim-bookworm

# Install system dependencies required for RDKit
RUN apt-get update && apt-get install -y \
    libxrender1 \
    libxext6 \
    libsm6 \
    libice6 \
    libx11-6 \
    libglib2.0-0 \
    libfontconfig1 \
    libfreetype6 \
    && rm -rf /var/lib/apt/lists/*

# Get uv from the official image
COPY --from=ghcr.io/astral-sh/uv:0.6.3 /uv /uvx /bin/

WORKDIR /app

COPY pyproject.toml uv.lock README.md ./

RUN uv sync --no-dev

COPY src ./src
COPY data ./data
COPY scripts ./scripts

EXPOSE 8050

CMD ["uv", "run", "gunicorn", "src.main:server", "-b", "0.0.0.0:8050"]
