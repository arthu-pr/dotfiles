
# Custom functions

# Build and install a .deb package from a directory
function deb_build() {
  dpkg-deb --build "$1"
  sudo apt install "./$1.deb"
}

pkgsize() {
  # Get package name and installed size
  dpkg-query --show --showformat='${Package;-50}\t${Installed-Size}\n' |
  # Sort largest first
  sort -k 2 -n |
  # Omit packages scheduled for deletion
  grep -v deinstall |
  # Convert KiB → MiB
  awk '{printf "%.3f MB\t%s\n", $2/1024, $1}'
}
