# Dotfiles

My personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

<img width="1920" height="1080" alt="image_57" src="https://github.com/user-attachments/assets/d06e6e2f-0e45-4dba-86ce-926b876984ad" />

<img width="1920" height="1080" alt="image_54" src="https://github.com/user-attachments/assets/013efa47-7a03-4024-94f7-4047b2ac374c" />

## Requirements

The following software is required to fully utilize the configurations provided in this repository (specifically the Hyprland setup).

### Core & Window Management
*   **Hyprland**: The tiling window manager.
*   **Waybar**: Status bar.
*   **SwayNC**: Notification daemon.
*   **Walker**: Application launcher.
*   **Hyprpaper**: Wallpaper utility.
*   **Swayidle**: Idle management daemon.
*   **Polkit-Gnome**: Authentication agent.
*   **Gnome Keyring**: Secrets management.

### Tools & Utilities
*   **Wlogout**: Logout menu.
*   **Hyprshot**: Screenshot utility.
*   **Hyprpicker**: Color picker.
*   **Wob**: Wayland Overlay Bar (for volume/brightness indicators).
*   **Wljoywake**: Prevent sleep on controller input.
*   **NM-Applet**: Network Manager system tray applet.
*   **Blueman**: Bluetooth manager.
*   **Brightnessctl**: Screen brightness control.
*   **Playerctl**: Media playback control.
*   **Imagepicker**: Backend for the wallpaper selector. (https://github.com/Disklo/imagepicker)
*   **Elephant**: Backend for Walker.
*   **obs-cmd**: Command line tool for controlling OBS Studio.

### Applications
*   **Foot**: Terminal emulator.
*   **Fish**: Shell.
*   **Starship**: Cross-shell prompt.
*   **Thunar**: File manager.
*   **VS Code**: Code editor (referenced as `code`).
*   **Micro**: Terminal text editor.
*   **Btop++**: Resource monitor.
*   **Fastfetch**: System information fetcher.

## Automatic installation

To install these dotfiles, ensure you have [chezmoi](https://www.chezmoi.io/) and the programs listed above installed, then run:

```bash
chezmoi init --apply https://github.com/Disklo/dotfiles
```

If you've already cloned this repository:

```bash
chezmoi init --apply --source=$PWD
```

## Theming & Appearance

This setup uses a consistent Gruvbox Material theme across the system. Below are the specific components and installation instructions (assuming an Arch-based system with an AUR helper like `yay`).

### Icons & System Themes

**Icons:** [Gruvbox Plus](https://github.com/SylEleuth/gruvbox-plus-icon-pack)
```bash
yay -S gruvbox-plus-icon-theme-git
```
To apply it:
```bash
gsettings set org.gnome.desktop.interface icon-theme 'Gruvbox-Plus-Dark'
```
To set the folder colors, download the folder color changer script on the icon theme repository, then allow its execution with `chmod +x` and run:
```bash
sudo (path to script)/folders-color-chooser.sh --c=pistachio
```

**GTK Theme:** [Gruvbox Material GTK](https://github.com/TheGreatMcPain/gruvbox-material-gtk)
```bash
yay -S gruvbox-material-gtk-theme-git
```
To apply it:
```bash
gsettings set org.gnome.desktop.interface gtk-theme 'Gruvbox-Material-Dark'
```
You may also use nwg-look.

**QT Theme:** [Gruvbox Kvantum](https://github.com/TheSerphh/Gruvbox-Kvantum)
```bash
yay -S kvantum-theme-gruvbox-git
```
Use qt5ct, qt6ct and kvantum manager to apply the theme. As for qt5ct and qt6ct, I highly recommend the use of their respective patched versions:
```bash
yay -S qt5ct-kde qt6ct-kde
```

**Adwaita/Libadwaita Theme:** [Rewaita](https://github.com/SwordPuffin/Rewaita)
```bash
yay -S rewaita
```
Then open it and apply the built-in Gruvbox theme.

**Cursor:** [Capitaine Cursors](https://github.com/sainnhe/capitaine-cursors)
Download "Linux.zip" from the releases page, then extract the contents of the folder "Capitaine Cursors (Gruvbox)" to `/usr/share/icons/capitaine-cursors-gruvbox/`

### Application-specific Theming

**Firefox:** [Custom Firefox Color theme](https://color.firefox.com/?theme=XQAAAAI9AQAAAAAAAABBKYhm849SCia48_6EGccwS-xMDPsA3z21-ZkHMR68RWm6ZSBlkFnylGzRdfX3mZg4q0bP7pWy8JPnGjCixnrKO7fhlXBWUgMqcln92oXnfwX3nE5DPMIlrnlSlubIOp_SINOM4dw1LWs6Xn62CE0Eew7Lm4m5l4PEPRsr9nfZnqDXonWDleEE-4fr17Y6FXScel-8PSOWgkhr0DGEjMqj0NZPmovTNFg0I47_q08AAA)
1. Make sure to have the Firefox Color add-on installed
2. Install this [Firefox Color theme](https://color.firefox.com/?theme=XQAAAAI9AQAAAAAAAABBKYhm849SCia48_6EGccwS-xMDPsA3z21-ZkHMR68RWm6ZSBlkFnylGzRdfX3mZg4q0bP7pWy8JPnGjCixnrKO7fhlXBWUgMqcln92oXnfwX3nE5DPMIlrnlSlubIOp_SINOM4dw1LWs6Xn62CE0Eew7Lm4m5l4PEPRsr9nfZnqDXonWDleEE-4fr17Y6FXScel-8PSOWgkhr0DGEjMqj0NZPmovTNFg0I47_q08AAA)

**VS Code:** [Gruvbox Material](https://marketplace.visualstudio.com/items?itemName=sainnhe.gruvbox-material)
```bash
code --install-extension sainnhe.gruvbox-material
```

**Steam:** [AdwSteamGtk](https://github.com/Foldex/AdwSteamGtk)
```bash
yay -S adwsteamgtk
```
Then open it and apply the built-in Gruvbox theme.

**Spotify:** [Spicetify Text Theme](https://github.com/spicetify/spicetify-themes/tree/master/text)
1. Install [Spicetify CLI](https://github.com/spicetify/spicetify-cli).
2. Install the [spicetify-themes](https://github.com/spicetify/spicetify-themes).
3. Apply the "text" theme:
```bash
spicetify config current_theme text
spicetify apply
```

**Krita:**
The color scheme is included in this repository at `~/.local/share/krita/color-schemes/gruvboxmaterial.colors`.
1. Open Krita.
2. Go to **Settings** -> **Manage Resources...** -> **Import Resource**.
3. Navigate to `~/.local/share/krita/color-schemes/` and select `gruvboxmaterial.colors`
4. Go to **Settings** -> **Configure Krita...** -> **Color Scheme**.
5. Select **Gruvbox Material Dark** from the list.
6. Click **OK**.

## Credits
- **Waybar CSS base:** https://github.com/timkicker/dotfiles
