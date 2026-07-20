-- ╔══════════════════════════════════════════════════════════════╗
-- ║                   Windowrules Configuration                 ║
-- ╚══════════════════════════════════════════════════════════════╝

-- Windows Rules https://wiki.hyprland.org/Configuring/Window-Rules/

-- ─── Float Necessary Windows ───────────────────────────────────

hl.window_rule({
    name = "windowrule-1",
    float = true,
    match = { class = "^(org.pulseaudio.pavucontrol)" },
})

hl.window_rule({
    name = "windowrule-2",
    float = true,
    match = { class = "^()$", title = "^(Picture in picture)$" },
})

hl.window_rule({
    name = "windowrule-3",
    float = true,
    match = { class = "^()$", title = "^(Save File)$" },
})

hl.window_rule({
    name = "windowrule-4",
    float = true,
    match = { class = "^()$", title = "^(Open File)$" },
})

hl.window_rule({
    name = "windowrule-5",
    float = true,
    match = { class = "^(LibreWolf)$", title = "^(Picture-in-Picture)$" },
})

hl.window_rule({
    name = "windowrule-6",
    float = true,
    match = { class = "^(blueman-manager)$" },
})

hl.window_rule({
    name = "windowrule-7",
    float = true,
    match = { class = "^(xdg-desktop-portal-gtk|xdg-desktop-portal-kde|xdg-desktop-portal-hyprland)(.*)$" },
})

hl.window_rule({
    name = "windowrule-8",
    float = true,
    match = { class = "^(polkit-gnome-authentication-agent-1|hyprpolkitagent|org.org.kde.polkit-kde-authentication-agent-1)(.*)$" },
})

hl.window_rule({
    name = "windowrule-9",
    float = true,
    match = { class = "^(CachyOSHello)$" },
})

hl.window_rule({
    name = "windowrule-10",
    float = true,
    match = { class = "^(zenity)$" },
})

hl.window_rule({
    name = "windowrule-11",
    float = true,
    match = { class = "^()$", title = "^(Steam - Self Updater)$" },
})

-- GIMP
hl.window_rule({
    name = "windowrule-12",
    float = true,
    match = { class = "^(file-.*)$" },
})

hl.window_rule({
    name = "windowrule-14",
    float = true,
    match = { class = "^(Emulator)$" },
})

-- Increase the opacity
hl.window_rule({
    name = "windowrule-15",
    opacity = "0.92",
    match = { class = "^(thunar|nemo)$" },
})

hl.window_rule({
    name = "windowrule-16",
    opacity = "0.96",
    match = { class = "^(discord|armcord|webcord|vencord)$" },
})

hl.window_rule({
    name = "windowrule-17",
    opacity = "0.95",
    match = { title = "^(QQ|Telegram)$" },
})

hl.window_rule({
    name = "windowrule-18",
    opacity = "0.95",
    match = { title = "^(NetEase Cloud Music Gtk4)$" },
})

-- General window rules
hl.window_rule({
    name = "windowrule-19",
    float = true,
    size = { 960, 540 },
    move = { "(monitor_w*0.25)", "0" },
    match = { title = "^(Picture-in-Picture)$" },
})

hl.window_rule({
    name = "windowrule-20",
    float = true,
    move = { "(monitor_w*0.25)", "0" },
    size = { 960, 540 },
    match = { title = "^(imv|mpv|danmufloat|termfloat|nemo|ncmpcpp)$" },
})

hl.window_rule({
    name = "windowrule-21",
    pin = true,
    match = { title = "^(danmufloat)$" },
})

hl.window_rule({
    name = "windowrule-22",
    rounding = 5,
    match = { title = "^(danmufloat|termfloat)$" },
})

-- hl.window_rule({
--     name = "windowrule-23",
--     animation = "slide right",
--     match = { class = "^(kitty|Alacritty|foot)$" },
-- })

hl.window_rule({
    name = "windowrule-24",
    no_blur = true,
    match = { class = "^(org.mozilla.firefox)$" },
})

hl.window_rule({
	name = "windowrule-foot",
	no_auto_hdr = true,
	match = { class = "^(foot)$"},
})

hl.window_rule({
    name = "osu!",
    match = { class = "^(osu!)$" },
    fullscreen_state = "2 2",
    suppress_event = "fullscreen maximize",
    stay_focused = true,
})

-- Decorations related to floating windows on workspaces 1 to 10
hl.window_rule({
    name = "windowrule-25",
    border_size = 2,
    border_color = gruvyellow,
    rounding = 8,
    match = { float = true, workspace = "w[fv1-10]" },
    no_blur = true,
})

hl.window_rule({
    name = "openscreen",
    match = { class = "^(openscreen)$" },
    border_size = 0,
})

-- Android Studio Emulator
hl.window_rule({
    name = "windowrule-13",
    float = true,
    opaque = true,
    border_size = 0,
    match = { initial_class = "^(Emulator)$" },
})

-- Decorations related to tiling windows on workspaces 1 to 10
hl.window_rule({
    name = "windowrule-26",
    border_size = 3,
    rounding = 4,
    match = { float = false, workspace = "f[1-10]" },
})

-- ╔══════════════════════════════════════════════════════════════╗
-- ║                     Workspace Rules                         ║
-- ╚══════════════════════════════════════════════════════════════╝

-- Workspaces Rules https://wiki.hyprland.org/Configuring/Workspace-Rules/
-- workspace = 1, default:true, monitor:$priMon
-- workspace = 6, default:true, monitor:$secMon
-- Workspace selectors https://wiki.hyprland.org/Configuring/Workspace-Rules/#workspace-selectors
-- workspace = r[1-5], monitor:$priMon
-- workspace = r[6-10], monitor:$secMon
-- workspace = special:scratchpad, on-created-empty:$applauncher
-- no_gaps_when_only deprecated instead workspaces rules with selectors can do the same
-- Smart gaps from 0.45.0 https://wiki.hyprland.org/Configuring/Workspace-Rules/#smart-gaps

hl.workspace_rule({ workspace = "w[tv1-10]", gaps_out = 5, gaps_in = 3 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 5, gaps_in = 3 })

-- ╔══════════════════════════════════════════════════════════════╗
-- ║                       Layer Rules                           ║
-- ╚══════════════════════════════════════════════════════════════╝

hl.layer_rule({
    name = "layerrule-1",
    animation = "slide top",
    match = { namespace = "logout_dialog" },
})

hl.layer_rule({
    name = "layerrule-2",
    animation = "slide down",
    match = { namespace = "waybar" },
})

hl.layer_rule({
    name = "layerrule-3",
    animation = "fade 50%",
    match = { namespace = "wallpaper" },
})

hl.layer_rule({
    no_anim = true,
    match = { class = "selector" },
})

-- ╔══════════════════════════════════════════════════════════════╗
-- ║                        Gestures                             ║
-- ╚══════════════════════════════════════════════════════════════╝

hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "down", action = "close" })
hl.gesture({ fingers = 3, direction = "up", action = "fullscreen" })
hl.gesture({ fingers = 3, direction = "left", action = "float" })
