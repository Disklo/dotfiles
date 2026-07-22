#!/usr/bin/env bash

IMAGE="/tmp/ocr_capture.png"
MODEL="$HOME/.local/share/models/paddleocr/PaddleOCR-VL-1.6-GGUF.gguf"
MMPROJ="$HOME/.local/share/models/paddleocr/PaddleOCR-VL-1.6-GGUF-mmproj.gguf"
RAW_FILE="/tmp/ocr_raw_output.txt"
DEBUG="/tmp/ocr_debug.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$DEBUG"
}
echo "[$(date '+%Y-%m-%d %H:%M:%S')] New OCR Session Started" > "$DEBUG"

if [ ! -f "$MODEL" ] || [ ! -f "$MMPROJ" ]; then
    log "ERROR: Model or mmproj file missing at specified paths"
    notify-send -u critical "OCR Failed" "Model files not found"
    exit 1
fi

rm -f "$IMAGE" "$RAW_FILE"

log "Capturing image with hyprshot..."
hyprshot -m region --freeze -s -o /tmp -f ocr_capture.png
killall -q hyprpicker

if [ ! -f "$IMAGE" ]; then
    log "WARNING: No image captured"
    exit 0
fi

IMAGE_SIZE=$(stat -c%s "$IMAGE" 2>/dev/null || wc -c < "$IMAGE")
log "Image captured successfully. Size: $IMAGE_SIZE bytes."

IMG_W=$(identify -format "%w" "$IMAGE" 2>/dev/null)
IMG_H=$(identify -format "%h" "$IMAGE" 2>/dev/null)

if [ -z "$IMG_W" ] || [ -z "$IMG_H" ]; then
    DIMENSIONS=$(file "$IMAGE" | grep -E -o '[0-9]+ x [0-9]+' | head -1)
    IMG_W=$(echo "$DIMENSIONS" | awk '{print $1}')
    IMG_H=$(echo "$DIMENSIONS" | awk '{print $3}')
fi

if [ -n "$IMG_W" ] && [ -n "$IMG_H" ]; then
    if [ "$IMG_W" -le 10 ] && [ "$IMG_H" -le 10 ]; then
        log "WARNING: Image dimensions (${IMG_W}x${IMG_H}) are 10x10 or smaller. Cancelling"
        notify-send -t 2000 "OCR Cancelled" "The selected area is too small"
        rm -f "$IMAGE"
        exit 0
    fi
fi

# Start OCR
notify-send -t 2000 "OCR" "Processing image..."

log "Starting llama-cli..."
START_TIME=$(date +%s)

script -q -c "llama-cli \
  -m '$MODEL' \
  --mmproj '$MMPROJ' \
  -ngl 99 \
  --image '$IMAGE' \
  -c 4096 \
  --temp 0.1 \
  --top-k 1 \
  -n 512 \
  -st \
  --no-display-prompt \
  -p '<image>Text Recognition:'" /dev/null > "$RAW_FILE" 2>>"$DEBUG"

LLAMA_EXIT=$?
END_TIME=$(date +%s)

log "llama-cli completed in $((END_TIME - START_TIME)) seconds. (Exit code: $LLAMA_EXIT)"

if [ ! -f "$RAW_FILE" ]; then
    log "ERROR: Raw output file was not created"
    notify-send -u critical "OCR Failed" "Llama-cli failed to produce output"
    exit 1
fi

RAW_SIZE=$(wc -c < "$RAW_FILE")
log "Raw output size: $RAW_SIZE bytes."

TEXT=$(cat "$RAW_FILE" | sed $'s/\033\\[[0-9;]*[a-zA-Z]//g')

TEXT=$(echo "$TEXT" | sed -n '/Text Recognition:/,/^\[/p' | sed '1d;$d' | sed '/^$/d')

log "Final TEXT length: ${#TEXT} characters"
log "Final TEXT preview: $(echo "$TEXT" | head -c 100 | tr '\n' ' ')"

if [ -n "${TEXT//[$'\n\r\t ']}" ]; then
    printf "%s" "$TEXT" | wl-copy
    PREVIEW=$(echo "$TEXT" | head -1)
    [ ${#PREVIEW} -gt 100 ] && PREVIEW="${PREVIEW:0:100}..."
    notify-send "OCR Complete" "$PREVIEW"
    log "SUCCESS: OCR complete, text copied to clipboard."
else
    notify-send -u critical "OCR Failed" "No text detected"
    log "FAIL: No text detected by llama-cli"
fi

rm -f "$IMAGE" "$RAW_FILE"
log "Cleanup complete. Session ended."
