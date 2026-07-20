#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# --- Aliases ---
alias ls='ls --color=auto'
alias grep='grep --color=auto'
# Remove orphan packages
alias pacorphans='pacman -Qdtq | sudo pacman -Rns -'

# --- Command prompt ---
PS1='[\u@\h \W]\$ '
