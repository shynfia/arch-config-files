# ----------------------
# --- Audio packages ---
# ----------------------
AddPackage lib32-pipewire 	    # Low-latency audio/video router and processor - 32-bit
AddPackage lib32-pipewire-jack 	# Low-latency audio/video router and processor - 32-bit - JACK support
AddPackage pipewire 		    # Low-latency audio/video router and processor
AddPackage pipewire-alsa 	    # Low-latency audio/video router and processor - ALSA configuration
AddPackage pipewire-audio 	    # Low-latency audio/video router and processor - Audio support
AddPackage pipewire-jack 	    # Low-latency audio/video router and processor - JACK replacement
AddPackage pipewire-pulse 	    # Low-latency audio/video router and processor - PulseAudio replacement
AddPackage wireplumber 		    # Session / policy manager implementation for PipeWire

# Pipewire services
CreateLink /etc/systemd/user/pipewire-session-manager.service /usr/lib/systemd/user/wireplumber.service
CreateLink /etc/systemd/user/pipewire.service.wants/wireplumber.service /usr/lib/systemd/user/wireplumber.service
CreateLink /etc/systemd/user/sockets.target.wants/pipewire-pulse.socket /usr/lib/systemd/user/pipewire-pulse.socket
CreateLink /etc/systemd/user/sockets.target.wants/pipewire.socket /usr/lib/systemd/user/pipewire.socket

# --------------------------------------
# --- Graphics drivers and utilities ---
# --------------------------------------
AddPackage nvtop 			# GPUs process monitoring for AMD, Intel and NVIDIA

if [[ "$HOSTNAME" == "rocaterra" ]]; then
    # Hybrid graphics -- Intel and NVIDIA graphics drivers and utilities
    AddPackage switcheroo-control   # D-Bus service to check the availability of dual-GPU - required in order to respect the PrefersNonDefaultGPU setting in .desktop files
    AddPackage lib32-mesa 			# Open-source OpenGL drivers - 32-bit
    AddPackage lib32-vulkan-intel 	# Open-source Vulkan driver for Intel GPUs - 32-bit
    AddPackage vulkan-intel 		# Open-source Vulkan driver for Intel GPUs
    AddPackage --foreign lib32-nvidia-580xx-utils 	# NVIDIA drivers utilities (32-bit) (580xx) - Includes Vulkan NVIDIA driver (32-bit)
    AddPackage --foreign nvidia-580xx-dkms 		    # NVIDIA kernel modules - module sources (580xx) - Pulls nvidia-580xx-utils, which includes the Vulkan NVIDIA driver

    # NVIDIA services
    CreateLink /etc/systemd/system/systemd-hibernate.service.wants/nvidia-hibernate.service /usr/lib/systemd/system/nvidia-hibernate.service
    CreateLink /etc/systemd/system/systemd-hibernate.service.wants/nvidia-resume.service /usr/lib/systemd/system/nvidia-resume.service
    CreateLink /etc/systemd/system/systemd-suspend-then-hibernate.service.wants/nvidia-resume.service /usr/lib/systemd/system/nvidia-resume.service
    CreateLink /etc/systemd/system/systemd-suspend.service.wants/nvidia-resume.service /usr/lib/systemd/system/nvidia-resume.service
    CreateLink /etc/systemd/system/systemd-suspend.service.wants/nvidia-suspend.service /usr/lib/systemd/system/nvidia-suspend.service

    # Switcheroo service -- if not enabled, discrete GPU detection does not work
    CreateLink /etc/systemd/system/graphical.target.wants/switcheroo-control.service /usr/lib/systemd/system/switcheroo-control.service
fi

# -------------
# --- Fonts ---
# -------------
AddPackage noto-fonts 		# Google Noto TTF fonts - provides ttf-font; pinned dependency for KDE Plasma
AddPackage noto-fonts-cjk 	# Google Noto CJK fonts
AddPackage ttf-liberation   # Font family which aims at metric compatibility with Arial, Times New Roman, and Courier New

# Font configuration
CreateLink /etc/fonts/conf.d/10-hinting-slight.conf /usr/share/fontconfig/conf.default/10-hinting-slight.conf
CreateLink /etc/fonts/conf.d/10-scale-bitmap-fonts.conf /usr/share/fontconfig/conf.default/10-scale-bitmap-fonts.conf
CreateLink /etc/fonts/conf.d/10-yes-antialias.conf /usr/share/fontconfig/conf.default/10-yes-antialias.conf
CreateLink /etc/fonts/conf.d/11-lcdfilter-default.conf /usr/share/fontconfig/conf.default/11-lcdfilter-default.conf
CreateLink /etc/fonts/conf.d/20-unhint-small-vera.conf /usr/share/fontconfig/conf.default/20-unhint-small-vera.conf
CreateLink /etc/fonts/conf.d/30-metric-aliases.conf /usr/share/fontconfig/conf.default/30-metric-aliases.conf
CreateLink /etc/fonts/conf.d/40-nonlatin.conf /usr/share/fontconfig/conf.default/40-nonlatin.conf
CreateLink /etc/fonts/conf.d/45-generic.conf /usr/share/fontconfig/conf.default/45-generic.conf
CreateLink /etc/fonts/conf.d/45-latin.conf /usr/share/fontconfig/conf.default/45-latin.conf
CreateLink /etc/fonts/conf.d/48-spacing.conf /usr/share/fontconfig/conf.default/48-spacing.conf
CreateLink /etc/fonts/conf.d/49-sansserif.conf /usr/share/fontconfig/conf.default/49-sansserif.conf
CreateLink /etc/fonts/conf.d/50-user.conf /usr/share/fontconfig/conf.default/50-user.conf
CreateLink /etc/fonts/conf.d/51-local.conf /usr/share/fontconfig/conf.default/51-local.conf
CreateLink /etc/fonts/conf.d/60-generic.conf /usr/share/fontconfig/conf.default/60-generic.conf
CreateLink /etc/fonts/conf.d/60-latin.conf /usr/share/fontconfig/conf.default/60-latin.conf
CreateLink /etc/fonts/conf.d/65-fonts-persian.conf /usr/share/fontconfig/conf.default/65-fonts-persian.conf
CreateLink /etc/fonts/conf.d/65-nonlatin.conf /usr/share/fontconfig/conf.default/65-nonlatin.conf
CreateLink /etc/fonts/conf.d/69-unifont.conf /usr/share/fontconfig/conf.default/69-unifont.conf
CreateLink /etc/fonts/conf.d/80-delicious.conf /usr/share/fontconfig/conf.default/80-delicious.conf
CreateLink /etc/fonts/conf.d/90-synthetic.conf /usr/share/fontconfig/conf.default/90-synthetic.conf

# Noto fonts configuration
CreateLink /etc/fonts/conf.d/46-noto-sans.conf /usr/share/fontconfig/conf.default/46-noto-sans.conf
CreateLink /etc/fonts/conf.d/46-noto-serif.conf /usr/share/fontconfig/conf.default/46-noto-serif.conf
CreateLink /etc/fonts/conf.d/66-noto-sans.conf /usr/share/fontconfig/conf.default/66-noto-sans.conf
CreateLink /etc/fonts/conf.d/66-noto-serif.conf /usr/share/fontconfig/conf.default/66-noto-serif.conf

# Liberation configuration
CreateLink /etc/fonts/conf.d/48-guessfamily.conf /usr/share/fontconfig/conf.default/48-guessfamily.conf

# ---------------------------
# --- Desktop Environment ---
# ---------------------------
AddPackage plasma-meta 			    # Meta package to install KDE Plasma
AddPackage qt6-multimedia-ffmpeg 	# FFMpeg backend for qt6-multimedia - provides qt6-multimedia; pinned dependency
AddPackage xdg-desktop-portal 	    # Desktop integration portals for sandboxed apps - screen sharing

# Start plasma on boot
CreateLink /etc/systemd/system/display-manager.service /usr/lib/systemd/system/plasmalogin.service

# XDG User Directories service - keeps user dirs up to date
CreateLink /etc/systemd/user/graphical-session-pre.target.wants/xdg-user-dirs.service /usr/lib/systemd/user/xdg-user-dirs.service

# -----------
# --- GTK ---
# -----------
# Install input method, required for GTK apps to correctly process non-ASCII characters
AddPackage fcitx5               # Next generation of fcitx, cross-platform input method framework
AddPackage fcitx5-configtool    # Configuration Tool for Fcitx5
AddPackage fcitx5-gtk           # Fcitx5 gtk im module and glib based dbus client library
AddPackage fcitx5-qt            # Fcitx5 Qt Library (Qt5 & Qt6 integrations)
