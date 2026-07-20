-- ╔══════════════════════════════════════════════════════════════╗
-- ║                   Autostart Configuration                   ║
-- ╚══════════════════════════════════════════════════════════════╝

-- Autostart wiki https://wiki.hyprland.org/Configuring/Keywords/#executing

hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user import-environment")
    hl.exec_cmd("hash dbus-update-activation-environment 2>/dev/null")
    hl.exec_cmd("dbus-update-activation-environment --systemd")

    hl.exec_cmd("/usr/bin/gnome-keyring-daemon --start --components=secrets,ssh,gpg")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("waybar")
    hl.exec_cmd("fcitx5 -d")
    hl.exec_cmd("swaync")
    hl.exec_cmd("nm-applet --indicator")

    hl.exec_cmd('bash -c "mkfifo /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob && tail -f /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob | wob"')

    hl.exec_cmd("elephant")
    hl.exec_cmd("walker --gapplication-service")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("wljoywake")
    hl.exec_cmd("udiskie --smart-tray")
    hl.exec_cmd("wl-clip-persist --clipboard regular")

    hl.exec_cmd("hypridle")

    hl.exec_cmd("hyprctl setcursor capitaine-cursors-gruvbox 24")
end)
