# Arch Config Files

## After `aconfmgr apply`
Reinstall the following packages so their hooks trigger (when `aconfmgr` first installs them, hooks aren't in place yet).
- `edk2-shell` — Will copy UEFI shell to ESP
- `vintagestory` — Only if computer has hybrid graphics. Will update its desktop entry so it uses the discrete GPU

## Dotfiles

### Non-XDG-compliant files and folders in home folder
- `.gtkrc-2.0` — GTK settings, written by Plasma's GNOME/GTK Settings Synchronization Service
- `.pki` — Electron/Chromium
- `.pulse-cookie` — PulseAudio. Keeps appearing in home folder even though it shouldn't. I have no idea why
- `.steam`, `.steampath` and `.steampid` — Steam
- `.var` — Flatpak
- `.vscode-oss` and `.vscode-oss-shared` — VSCode
