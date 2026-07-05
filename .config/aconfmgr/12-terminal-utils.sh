AddPackage bash-completion          # Programmable completion for the bash shell
AddPackage ex-vi-compat             # The ex and vi commands based on vim's compatibility modes
AddPackage nano 			        # Pico editor clone with enhancements
AddPackage nano-syntax-highlighting # Nano editor syntax highlighting enhancements

# XDG Base Directory configuration
cat > "$(CreateFile /etc/profile.d/00-xdg-base-directory.sh)" <<EOF
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