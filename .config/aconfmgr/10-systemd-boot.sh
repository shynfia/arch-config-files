AddPackage --foreign archiso-systemd-boot # archiso as systemd-boot loader entry

# Pacman hook to update systemd-boot
cat > "$(CreateFile /etc/pacman.d/hooks/95-systemd-boot.hook)" <<EOF
[Trigger]
Type = Package
Operation = Upgrade
Target = systemd

[Action]
Description = Gracefully upgrading systemd-boot...
When = PostTransaction
Exec = /usr/bin/systemctl restart systemd-boot-update.service
EOF

# ---------------------------------
# --- Menu entries and settings ---
# ---------------------------------
# Arch entry
cat > "$(CreateFile /boot/loader/entries/arch.conf)" <<EOF
title Arch Linux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options root=/dev/vg_ssd/root rw
EOF

# Arch fallback entry
cat > "$(CreateFile /boot/loader/entries/arch-fallback.conf)" <<EOF
title Arch Linux Fallback
linux /vmlinuz-linux
initrd /initramfs-linux-fallback.img
options root=/dev/vg_ssd/root rw
EOF

# Menu settings
cat > "$(CreateFile /efi/loader/loader.conf)" <<EOF
default arch.conf
timeout 0
console-mode auto
editor false
auto-firmware true
auto-reboot true
auto-poweroff true
EOF

# This command will not have an effect since /efi is a FAT32 system with no support for Linux permissions,
# but having it here prevents aconfmgr from including it in every save
SetFileProperty /efi/loader/loader.conf mode 755

# ------------------
# --- UEFI shell ---
# ------------------
AddPackage edk2-shell # EDK2 UEFI Shell

cat > "$(CreateFile /etc/pacman.d/hooks/50-uefi-shell.hook)" <<EOF
[Trigger]
Type = Package
Operation = Install
Operation = Upgrade
Target = edk2-shell

[Action]
Description = Copying UEFI shell to ESP...
When = PostTransaction
Exec = /usr/bin/cp /usr/share/edk2-shell/x64/Shell.efi /efi/shellx64.efi
EOF

# ---------------
# --- MemTest ---
# ---------------
AddPackage memtest86+-efi # Advanced memory diagnostic tool EFI version

cat > "$(CreateFile /boot/loader/entries/memtest.conf)" <<EOF
title Memtest86+
efi /memtest86+/memtest.efi
EOF