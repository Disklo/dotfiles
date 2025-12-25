#!/usr/bin/env bash

ACTIVE_WIN=$(hyprctl activewindow -j)
if [ -z "$ACTIVE_WIN" ];
then
  exit 1
fi

WINDOW_ADDRESS=$(echo "$ACTIVE_WIN" | jq -r '.address')

STATE_FILE="/tmp/hypr_pseudo_fullscreen_${WINDOW_ADDRESS}.state"

MONITOR=$(echo "$ACTIVE_WIN" | jq -r '.monitor')
MONITOR_INFO=$(hyprctl monitors -j | jq -r ".[] | select(.id==$MONITOR)")
MON_X=$(echo "$MONITOR_INFO" | jq -r '.x')
MON_Y=$(echo "$MONITOR_INFO" | jq -r '.y')
MON_W=$(echo "$MONITOR_INFO" | jq -r '.width')
MON_H=$(echo "$MONITOR_INFO" | jq -r '.height')

if [ ! -f "$STATE_FILE" ]; then
  WAS_FLOATING=$(echo "$ACTIVE_WIN" | jq -r '.floating')

  if [ "$WAS_FLOATING" = "true" ]; then
    WIN_X=$(echo "$ACTIVE_WIN" | jq -r '.at[0]')
    WIN_Y=$(echo "$ACTIVE_WIN" | jq -r '.at[1]')
    WIN_W=$(echo "$ACTIVE_WIN" | jq -r '.size[0]')
    WIN_H=$(echo "$ACTIVE_WIN" | jq -r '.size[1]')
    echo "$WAS_FLOATING,$WIN_X,$WIN_Y,$WIN_W,$WIN_H" > "$STATE_FILE"
  else
    echo "$WAS_FLOATING" > "$STATE_FILE"
  fi

  if [ "$WAS_FLOATING" = "false" ]; then
    hyprctl dispatch setfloating address:$WINDOW_ADDRESS
    sleep 0.05
  fi

  hyprctl --batch \
    "dispatch movewindowpixel exact $MON_X $MON_Y,address:$WINDOW_ADDRESS; \
     dispatch resizewindowpixel exact $MON_W $MON_H,address:$WINDOW_ADDRESS; \
     dispatch setprop address:$WINDOW_ADDRESS noborder 1; \
     dispatch setprop address:$WINDOW_ADDRESS norounding 1; \
     dispatch focuswindow address:$WINDOW_ADDRESS; \
     dispatch bringactivetotop"

else
  STATE_DATA=$(cat "$STATE_FILE")
  rm -f "$STATE_FILE"

  WAS_FLOATING=$(echo "$STATE_DATA" | cut -d',' -f1)

  hyprctl --batch \
    "dispatch setprop address:$WINDOW_ADDRESS noborder 0; \
     dispatch setprop address:$WINDOW_ADDRESS norounding 0"
  
  sleep 0.05

  if [ "$WAS_FLOATING" = "false" ]; then
    hyprctl dispatch togglefloating address:$WINDOW_ADDRESS
  else
    WIN_X=$(echo "$STATE_DATA" | cut -d',' -f2)
    WIN_Y=$(echo "$STATE_DATA" | cut -d',' -f3)
    WIN_W=$(echo "$STATE_DATA" | cut -d',' -f4)
    WIN_H=$(echo "$STATE_DATA" | cut -d',' -f5)
    
    hyprctl --batch \
      "dispatch movewindowpixel exact $WIN_X $WIN_Y,address:$WINDOW_ADDRESS; \
       dispatch resizewindowpixel exact $WIN_W $WIN_H,address:$WINDOW_ADDRESS"
  fi

fi