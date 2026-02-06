# wyoming-chatterbox

[wyoming protocol](https://github.com/rhasspy/wyoming) server for [chatterbox tts](https://github.com/resemble-ai/chatterbox) with voice cloning.

clone any voice with a 10-30 second audio sample.

## requirements

- nvidia gpu with 4gb+ vram
- cuda 12.x
- python 3.10+

## install

from source:
```bash
git clone https://github.com/sudoxreboot/wyoming-chatterbox
cd wyoming-chatterbox
pip install .
```

## usage

```bash
wyoming-chatterbox --uri tcp://0.0.0.0:10201 --voice-ref /path/to/voice_sample.wav
```

### options

| option | default | description |
|--------|---------|-------------|
| `--uri` | required | server uri (e.g., `tcp://0.0.0.0:10201`) |
| `--voice-ref` | required | path to voice reference wav (10-30s of speech) |
| `--volume-boost` | 3.0 | output volume multiplier |
| `--device` | cuda | torch device (`cuda` or `cpu`) |
| `--debug` | false | enable debug logging |

## voice reference tips

for best results:
- 10-30 seconds of clean speech
- no background music or noise
- consistent speaking style
- wav format (any sample rate)

## systemd service

```bash
sudo tee /etc/systemd/system/wyoming-chatterbox.service << 'EOF'
[Unit]
Description=Wyoming Chatterbox TTS
After=network-online.target

[Service]
Type=simple
User=YOUR_USER
Environment=PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True
ExecStart=/path/to/venv/bin/wyoming-chatterbox \
  --uri tcp://0.0.0.0:10201 \
  --voice-ref /path/to/voice_reference.wav \
  --volume-boost 3.0
Restart=always
RestartSec=5

[Install]
WantedBy=default.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now wyoming-chatterbox
```

## home assistant

1. settings → devices & services → add integration
2. search "wyoming protocol"
3. host: `YOUR_IP`, port: `10201`
4. use in your voice assistant pipeline as tts

## gpu memory

chatterbox uses ~3.5gb vram. if you get oom errors:

```bash
# check gpu usage
nvidia-smi

# kill zombie processes
pkill -f wyoming-chatterbox
```

## license

mit

---

<div align="center">

made by [sudoxnym](https://sudoxreboot.com) ⚡

</div>
