-- ╔══════════════════════════════════════════════════════════════╗
-- ║                   Variables Configuration                   ║
-- ╚══════════════════════════════════════════════════════════════╝

-- https://wiki.hyprland.org/Configuring/Variables/#general
hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 5,
        border_size = 3,
        col = {
            active_border = gruvyellow,
            inactive_border = gruvblack,
        },
        layout = "dwindle",
        resize_on_border = true,
        snap = {
            enabled = true,
        },
        allow_tearing = true,
    },
    ecosystem = {
        no_donation_nag = true,
    },
    group = {
        col = {
            border_active = gruvgreen,
            border_inactive = gruvcyan,
            border_locked_active = gruvgreen,
            border_locked_inactive = gruvblack,
        },
        groupbar = {
            font_family = "JetBrainsMono Nerd Font",
            text_color = gruvblack,
            col = {
                active = gruvgreen,
                inactive = gruvblack,
                locked_active = gruvgreen,
                locked_inactive = gruvblack,
            },
        },
    },
    misc = {
        font_family = "JetBrainsMono Nerd Font",
        splash_font_family = "JetBrainsMono Nerd Font",
        disable_hyprland_logo = true,
        col = {
            splash = gruvyellow,
        },
        background_color = gruvblack,
        enable_swallow = true,
        swallow_regex = "^(btrfs-assistant.)$",
        focus_on_activate = true,
        vrr = 2,
    },
    debug = {
        vfr = true,
    },
    render = {
        direct_scanout = false,
    },
    dwindle = {
        special_scale_factor = 0.8,
        preserve_split = true,
    },
    master = {
        new_status = "master",
        special_scale_factor = 0.8,
    },
})
