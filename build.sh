#!/usr/bin/env bash
set -e
export HOME=/home/builder
cd $HOME

# Add the SSH key
mkdir -p ~/.ssh
echo "${SSH_PRIVATE_KEY}" > ~/.ssh/private
chmod 600 ~/.ssh/private
eval $(ssh-agent -s)
ssh-add ~/.ssh/private

# Configure git
git config --global user.email "noreply@github.com"
git config --global user.name "GitHub Action"

# Added aur.archlinux.org as a known host
ssh-keyscan aur.archlinux.org >> ~/.ssh/known_hosts

# Install paru
pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 3056513887B78AEB
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
echo "[chaotic-aur]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf

# Clone the repo
git clone aur@aur.archlinux.org:${PKGNAME}.git
cd ${PKGNAME}

# Update the PKGBUILD
makepkg -s --noconfirm
rm .SRCINFO
makepkg --printsrcinfo > .SRCINFO
git add PKGBUILD .SRCINFO
git commit -m "Update to $(cat PKGBUILD | grep pkgver= | cut -d '=' -f 2)"
git push