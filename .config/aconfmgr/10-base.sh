# ---------------------
# --- Base packages ---
# ---------------------
AddPackage base                 # [Required] Minimal package set to define a basic Arch Linux installation
AddPackage base-devel 		# Basic tools to build Arch Linux packages - Required for AUR
AddPackage intel-ucode 		# Microcode update files for Intel CPUs
AddPackage linux 		# The Linux kernel and modules
AddPackage linux-firmware 	# Firmware files for Linux - Default set
AddPackage linux-headers        # Headers and scripts for building modules for the Linux kernel - required for building the NVIDIA drivers
AddPackage lvm2 		# Logical Volume Manager 2 utilities
AddPackage networkmanager 	# Network connection manager and user applications
AddPackage pacman-contrib       # Contributed scripts and tools for pacman systems
AddPackage pkgfile              # A tool to search for files in official repository packages
AddPackage reflector            # A Python 3 module and script to retrieve and filter the latest Pacman mirror list.
AddPackage sudo                 # Give certain users the ability to run some commands as root
AddPackage wireless-regdb 	# Central Regulatory Domain Database - Sometimes required for European wifi

# ------------------
# --- mkinitcpio ---
# ------------------
f="$(GetPackageOriginalFile mkinitcpio /etc/mkinitcpio.conf)"
# Add lvm2 to HOOKS array on line 55 (this way examples in the file are not modified)
sed -i '55 s/block filesystems/block lvm2 filesystems/' "$f"

# Add fallback initramfs
CopyFile /etc/mkinitcpio.d/linux.preset
AddPackage linux-firmware-qlogic        # Firmware files for Linux - Firmware for QLogic devices
AddPackage --foreign aic94xx-firmware   # Adaptec SAS 44300, 48300, 58300 Sequencer Firmware for AIC94xx driver
AddPackage --foreign ast-firmware       # Aspeed VGA module from the IPMI
AddPackage --foreign upd72020x-fw       # Renesas uPD720201 / uPD720202 USB 3.0 chipsets firmware
AddPackage --foreign wd719x-firmware    # Firmware for Western Digital WD7193, WD7197, and WD7296 SCSI cards

# ---------------------------------
# --- Package management config ---
# ---------------------------------
# Pacman config
CopyFile /etc/pacman.conf

# No debug packages
cat > "$(CreateFile /etc/makepkg.conf.d/no_debug.conf)" <<EOF
# Prevent creation of debug packages
OPTIONS+=(!debug)
EOF

# Clean pacman cache after every transaction
cat > "$(CreateFile /etc/pacman.d/hooks/10-pacman-cache.hook)" <<EOF
[Trigger]
Operation = Remove
Operation = Install
Operation = Upgrade
Type = Package
Target = *

[Action]
Description = Cleaning pacman cache...                        
When = PostTransaction
# Keep installed version + previous version
Exec = /usr/bin/paccache -rk2
EOF

# Log orphaned packages
cat > "$(CreateFile /etc/pacman.d/hooks/10-log-orphans.hook)" <<EOF
[Trigger]
Operation = Remove
Operation = Install
Operation = Upgrade
Type = Package
Target = *

[Action]
Description = Checking for orphan packages...
When = PostTransaction
Exec = /usr/bin/bash -c "/usr/bin/pacman -Qdt || /usr/bin/echo '=> None found.'"
EOF

# Log new .pacnew files
cat > "$(CreateFile /etc/pacman.d/hooks/90-log-pacnew-files.hook)" <<EOF
[Trigger]
Operation = Remove
Operation = Install
Operation = Upgrade
Type = Package
Target = *

[Action]
Description = Checking for .pacnew files...
When = PostTransaction
Exec = /usr/bin/pacdiff -o
EOF

# Set up reflector for auto-sorting of mirrors by download rate
CreateLink /etc/systemd/system/timers.target.wants/reflector.timer /usr/lib/systemd/system/reflector.timer
CopyFile /etc/xdg/reflector/reflector.conf

# Auto-update pkgfile database
CreateLink /etc/systemd/system/multi-user.target.wants/pkgfile-update.timer /usr/lib/systemd/system/pkgfile-update.timer

# -------------
# --- fstab ---
# -------------
root_uuid=$(findmnt -no UUID /)
efi_uuid=$(findmnt -no UUID /efi)
boot_uuid=$(findmnt -no UUID /boot)
data_uuid=$(findmnt -no UUID /data)
swap_uuid=$(sudo blkid -s UUID -o value /dev/vg_ssd/swap)

cat > "$(CreateFile /etc/fstab)" <<EOF
# Static information about the filesystems.
# See fstab(5) for details.

# <file system> <dir> <type> <options> <dump> <pass>
# /dev/mapper/vg_ssd-root
UUID="$root_uuid"   /         	ext4      	rw,relatime	0 1

# /dev/sda1
UUID="$efi_uuid"    /efi      	vfat      	rw,relatime,nodev,nosuid,fmask=0022,dmask=0022,codepage=437,iocharset=ascii,shortname=mixed,utf8,errors=remount-ro	0 2

# /dev/sda2
UUID="$boot_uuid"   /boot     	ext4      	rw,relatime,nodev,nosuid	0 2

# /dev/mapper/vg_hdd-data
UUID="$data_uuid"   /data     	ext4      	rw,relatime,noexec,nodev,nosuid	0 2

# /dev/mapper/vg_ssd-swap
UUID="$swap_uuid"   none      	swap      	defaults  	0 0
EOF

# ---------------------------
# --- Hosts configuration ---
# ---------------------------
# Host name
echo "$HOSTNAME" > "$(CreateFile /etc/hostname)"

# Hostname resolution
f="$(GetPackageOriginalFile filesystem /etc/hosts)"
echo "127.0.1.1        $HOSTNAME" >> "$f"

# ------------------------
# --- systemd-resolved ---
# ------------------------
CreateLink /etc/resolv.conf ../run/systemd/resolve/stub-resolv.conf

# -------------------------
# --- Locale and region ---
# -------------------------
# System locales
f="$(GetPackageOriginalFile glibc /etc/locale.gen)"
sed -i 's/^#\(en_US.UTF-8\)/\1/g' "$f"
sed -i 's/^#\(es_ES.UTF-8\)/\1/g' "$f"

# Default language
echo "LANG=en_US.UTF-8" > "$(CreateFile /etc/locale.conf)"

# Region
CreateLink /etc/localtime /usr/share/zoneinfo/Europe/Madrid

# ----------------
# --- Keyboard ---
# ----------------
# tty keyboard layout
echo "KEYMAP=es" > "$(CreateFile /etc/vconsole.conf)"

# X11 keyboard layout configuration - required for plasmalogin and inherited by plasma
cat > "$(CreateFile /etc/X11/xorg.conf.d/00-keyboard.conf)" <<EOF
# Written by systemd-localed(8), read by systemd-localed and Xorg. It's
# probably wise not to edit this file manually. Use localectl(1) to
# update this file.
Section "InputClass"
        Identifier "system-keyboard"
        MatchIsKeyboard "on"
        Option "XkbLayout" "es"
EndSection
EOF

# ----------------------
# --- NetworkManager ---
# ----------------------
# Prevent normal users from creating system-wide connections by default
CopyFile /etc/polkit-1/rules.d/10-nm-no-system-wide.rules

# Enable NetworkManager service
CreateLink /etc/systemd/system/dbus-org.freedesktop.nm-dispatcher.service /usr/lib/systemd/system/NetworkManager-dispatcher.service
CreateLink /etc/systemd/system/network-online.target.wants/NetworkManager-wait-online.service /usr/lib/systemd/system/NetworkManager-wait-online.service
CreateLink /etc/systemd/system/multi-user.target.wants/NetworkManager.service /usr/lib/systemd/system/NetworkManager.service

# ------------
# --- sudo ---
# ------------
CopyFile /etc/sudoers

# ------------------------
# --- systemd services ---
# ------------------------
# getty - Arch TTY
CreateLink /etc/systemd/system/autovt@.service /usr/lib/systemd/system/getty@.service
CreateLink /etc/systemd/system/getty.target.wants/getty@tty1.service /usr/lib/systemd/system/getty@.service

# systemd-resolved - DNS resolver
CreateLink /etc/systemd/system/dbus-org.freedesktop.resolve1.service /usr/lib/systemd/system/systemd-resolved.service
CreateLink /etc/systemd/system/sockets.target.wants/systemd-resolved-monitor.socket /usr/lib/systemd/system/systemd-resolved-monitor.socket
CreateLink /etc/systemd/system/sockets.target.wants/systemd-resolved-varlink.socket /usr/lib/systemd/system/systemd-resolved-varlink.socket
CreateLink /etc/systemd/system/sysinit.target.wants/systemd-resolved.service /usr/lib/systemd/system/systemd-resolved.service

# systemd-timesyncd - Time sync service
CreateLink /etc/systemd/system/dbus-org.freedesktop.timesync1.service /usr/lib/systemd/system/systemd-timesyncd.service
CreateLink /etc/systemd/system/sysinit.target.wants/systemd-timesyncd.service /usr/lib/systemd/system/systemd-timesyncd.service

# Remote filesystem support
CreateLink /etc/systemd/system/multi-user.target.wants/remote-fs.target /usr/lib/systemd/system/remote-fs.target

# Other services enabled by default
CreateLink /etc/systemd/system/sockets.target.wants/systemd-userdbd.socket /usr/lib/systemd/system/systemd-userdbd.socket
CreateLink /etc/systemd/user/sockets.target.wants/p11-kit-server.socket /usr/lib/systemd/user/p11-kit-server.socket

# -----------------------
# --- systemd devices ---
# -----------------------
# Mask TPM device to disable TPM, should prevent hanging when shutting down
CreateLink /etc/systemd/system/dev-tpmrm0.device /dev/null

# ------------------
# --- Filesystem ---
# ------------------

# Introduced by a systemd update, permissions are modified from their default on boot
SetFileProperty / mode 555