-- ╔══════════════════════════════════════════════════════════════╗
-- ║                   Decorations Configuration                 ║
-- ╚══════════════════════════════════════════════════════════════╝

-- https://wiki.hyprland.org/Configuring/Variables/#decoration

hl.config({
    decoration = {
        active_opacity = 1,
        inactive_opacity = 0.86,
        rounding = 0,
        blur = {
            size = 12,
            passes = 2,
            xray = false,
        },
        shadow = {
            enabled = false,
        },
    },
})
