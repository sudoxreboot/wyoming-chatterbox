FROM python:3.11-slim

WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    HF_HOME=/cache/huggingface \
    PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True

RUN apt-get update && apt-get install -y --no-install-recommends \
    libsndfile1 \
    ffmpeg \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# install torch stack first from the cuda wheel index, pinned to a known-good set
# torchvision must match torch exactly or the C++ nms operator won't exist
RUN pip install --no-cache-dir \
    torch==2.6.0 \
    torchvision==0.21.0 \
    torchaudio==2.6.0 \
    --index-url https://download.pytorch.org/whl/cu124

# install chatterbox-tts with --no-deps to prevent it from clobbering the torch stack,
# then manually satisfy its remaining deps
RUN pip install --no-cache-dir --no-deps chatterbox-tts && \
    pip install --no-cache-dir \
    numpy \
    omegaconf \
    librosa \
    s3tokenizer \
    pykakasi \
    conformer \
    safetensors \
    transformers==4.46.3 \
    pyloudnorm \
    spacy-pkuseg \
    resemble-perth \
    diffusers==0.29.0 \
    soundfile \
    optree>=0.13.0

COPY pyproject.toml .
COPY wyoming_chatterbox/ ./wyoming_chatterbox/

RUN pip install --no-cache-dir .

VOLUME ["/cache", "/voice"]

ENTRYPOINT ["wyoming-chatterbox"]
CMD ["--uri", "tcp://0.0.0.0:10800", "--voice-ref", "/voice/reference.wav"]
