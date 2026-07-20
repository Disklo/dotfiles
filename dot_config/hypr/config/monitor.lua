-- ╔══════════════════════════════════════════════════════════════╗
-- ║                    Monitor Configuration                    ║
-- ╚══════════════════════════════════════════════════════════════╝

-- Monitor wiki https://wiki.hyprland.org/Configuring/Monitors/

hl.monitor({
    output = "DP-1",
    mode = "1920x1080@143.86",
    position = "0x0",
    scale = 1,
    bitdepth = 10,
})

-- If you need to scale things like steam etc, please uncomment these lines.
-- hl.config({
--     xwayland = {
--         force_zero_scaling = true,
--     },
-- })

-- Adjust GDK_SCALE accordingly to your liking.
-- hl.env("GDK_SCALE", "2")

-- Electron based apps use X11 as default, auto should detect wayland
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
