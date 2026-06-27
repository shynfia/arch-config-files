AddPackage sudo     # Give certain users the ability to run some commands as root

CopyFile /etc/sudoers
CopyFile /etc/sudoers.d/00-editor 440
CopyFile /etc/sudoers.d/10-wheel-group 440
CopyFile /etc/sudoers.d/20-timeouts 440
CopyFile /etc/sudoers.d/30-requiretty 440