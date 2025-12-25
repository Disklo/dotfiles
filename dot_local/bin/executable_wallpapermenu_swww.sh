#!/bin/bash

WALLPAPER_DIR="$HOME/.local/share/backgrounds"

if [[ ! -d "$WALLPAPER_DIR" ]]; then
    notify-send "Error" "Wallpaper directory not found: $WALLPAPER_DIR"
    exit 1
fi

mapfile -t wallpapers < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) -printf "%f\n" | sort)

if [[ ${#wallpapers[@]} -eq 0 ]]; then
    notify-send "Error" "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

if command -v imagepicker >/dev/null 2>&1; then
    WALLPAPER_PATH=$(imagepicker "$WALLPAPER_DIR")
    if [[ -z "$WALLPAPER_PATH" ]]; then
        exit 0
    fi
else
    selected=$(printf '%s\n' "${wallpapers[@]}" | fuzzel --dmenu --prompt "Select Wallpaper: ")
    if [[ -z "$selected" ]]; then
        exit 0
    fi
    WALLPAPER_PATH="$WALLPAPER_DIR/$selected"
fi

if command -v swww &> /dev/null; then
    SWWW_CMD="swww"
elif command -v awww &> /dev/null; then
    SWWW_CMD="awww"
else
    notify-send "Error" "Neither swww nor awww found."
    exit 1
fi

if ! $SWWW_CMD query &> /dev/null; then
    $SWWW_CMD init &
    sleep 0.5
fi

$SWWW_CMD img "$WALLPAPER_PATH" --transition-type any --transition-fps 144 --transition-duration 0.7 --transition-step 90

# Optional: Send notification
# notify-send "Wallpaper Changed" "Applied: $(basename "$WALLPAPER_PATH")"