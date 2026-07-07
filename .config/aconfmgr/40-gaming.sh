AddPackage steam                    # Valve's digital software delivery system
AddPackage --foreign vintagestory   # Uncompromising wilderness survival sandbox game (requires paid account)

AddPackage lutris # Open Gaming Platform
AddPackage umu-launcher # The Unified Launcher for Windows Games on Linux, to run Proton with fixes outside of Steam
AddPackage wine # A compatibility layer for running Windows programs
CreateLink /etc/fonts/conf.d/30-win32-aliases.conf /usr/share/fontconfig/conf.default/30-win32-aliases.conf


if [[ "$HOSTNAME" == "rocaterra" ]]; then
    cat > "$(CreateFile /etc/pacman.d/hooks/50-vintagestory.hook)" <<-EOF
		# Set up Vintage Story to use NVIDIA GPU
		[Trigger]
		Operation=Install
		Operation=Upgrade
		Type=Package
		Target=vintagestory

		[Action]
		Description=Adding PrefersNonDefaultGPU to vintagestory.deskop...
		When=PostTransaction
		# kbuildsycoca6 refreshes the .desktop cache. 
		# XDG_MENU_PREFIX is needed b/c by default it looks for applications.menu, which does not exist, and
		# this env variable is empty when the hook runs
		# We silence kbuildsycoca6 redirecting its output to /dev/null
		Exec=/usr/bin/bash -c 'echo "PrefersNonDefaultGPU=true" >> /usr/share/applications/vintagestory.desktop && XDG_MENU_PREFIX="plasma-" kbuildsycoca6 &> /dev/null'
	EOF
fi