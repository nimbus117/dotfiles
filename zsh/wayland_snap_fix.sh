mkdir -p ~/.config/environment.d
echo "PATH=$PATH:/snap/bin\nXDG_DATA_DIRS=\"${XDG_DATA_DIRS:-/usr/local/share:/usr/share}:/var/lib/snapd/desktop\"" > ~/.config/environment.d/60-snap-icons-and-bin.conf
