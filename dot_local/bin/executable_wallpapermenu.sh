#!/bin/bash

WALLPAPER_DIR="$HOME/.local/share/backgrounds"
HYPRPAPER_CONF="$HOME/.config/hypr/hyprpaper.conf"

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

hyprctl hyprpaper preload "$WALLPAPER_PATH"

for monitor in $(hyprctl monitors -j | jq -r '.[].name'); do
    hyprctl hyprpaper wallpaper "$monitor,$WALLPAPER_PATH"
done

hyprctl hyprpaper listloaded | while read -r loaded; do
    if [[ -n "$loaded" && "$loaded" != "$WALLPAPER_PATH" ]]; then
        hyprctl hyprpaper unload "$loaded"
    fi
done

if [[ -f "$HYPRPAPER_CONF" ]]; then
    # Remove old wallpaper blocks and preload lines
    sed -e '/wallpaper {/,/}/d' -e '/^preload = /d' "$HYPRPAPER_CONF" | sed '/^$/d' > "$HYPRPAPER_CONF.tmp"
    
    {
        for monitor in $(hyprctl monitors -j | jq -r '.[].name'); do
            echo "wallpaper {"
            echo "    monitor = $monitor"
            echo "    path = $WALLPAPER_PATH"
            echo "}"
        done
        echo ""
        cat "$HYPRPAPER_CONF.tmp"
    } > "$HYPRPAPER_CONF"
    
    rm "$HYPRPAPER_CONF.tmp"
fi

# Optional: Send notification
# notify-send "Wallpaper Changed" "Applied: $(basename "$WALLPAPER_PATH")"