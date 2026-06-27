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
