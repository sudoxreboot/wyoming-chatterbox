FROM pytorch/pytorch:2.4.0-cuda12.4-cudnn9-runtime

WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    HF_HOME=/cache/huggingface \
    PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True

RUN apt-get update && apt-get install -y --no-install-recommends \
    libsndfile1 \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

COPY pyproject.toml .
COPY wyoming_chatterbox/ ./wyoming_chatterbox/

RUN pip install --no-cache-dir . && \
    pip install --no-cache-dir chatterbox-tts

VOLUME ["/cache", "/voice"]

ENTRYPOINT ["wyoming-chatterbox"]
CMD ["--uri", "tcp://0.0.0.0:10800", "--voice-ref", "/voice/reference.wav"]
