AddPackage bash-completion          # Programmable completion for the bash shell
AddPackage dosfstools 		        # DOS filesystem utilities (FAT)
AddPackage e2fsprogs 		        # Ext2/3/4 filesystem utilities
AddPackage ex-vi-compat             # The ex and vi commands based on vim's compatibility modes
AddPackage gptfdisk                 # A text-mode partitioning tool that works on GUID Partition Table (GPT) disks
AddPackage man-db 			        # A utility for reading man pages
AddPackage man-pages 		        # Linux man pages
AddPackage nano 			        # Pico editor clone with enhancements
AddPackage nano-syntax-highlighting # Nano editor syntax highlighting enhancements
AddPackage texinfo 			        # GNU documentation system for on-line information and printed output
AddPackage yadm                     # Yet Another Dotfiles Manager

AddPackage --foreign aconfmgr-git	# A configuration manager for Arch Linux
AddPackage --foreign paru	        # Feature packed AUR helper


# XDG Base Directory configuration - quoted EOF to prevent variable substitution
cat > "$(CreateFile /etc/profile.d/00-xdg-base-directory.sh)" << 'EOF'
# https://wiki.archlinux.org/title/XDG_Base_Directory#Specification
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_CACHE_HOME="$HOME"/.cache
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_STATE_HOME="$HOME"/.local/state
export XDG_DATA_DIRS=/usr/local/share:/usr/share
export XDG_CONFIG_DIRS=/etc/xdg

# GnuPG
export GNUPGHOME="$XDG_DATA_HOME"/gnupg

# CUDA
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
EOF