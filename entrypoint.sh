#!/usr/bin/env bash
set -e

SSH_PRIVATE_KEY=$1
PKGNAME=$2

# Add the SSH key
mkdir -p ~/.ssh
echo "$SSH_PRIVATE_KEY" > ~/.ssh/private
chmod 600 ~/.ssh/private
eval $(ssh-agent -s)
ssh-add ~/.ssh/private

# Configure git
git config --global user.email "noreply@github.com"
git config --global user.name "GitHub Action"

# Added aur.archlinux.org as a known host
ssh-keyscan aur.archlinux.org >> ~/.ssh/known_hosts

# Clone the repo
git clone aur@aur.archlinux.org:${PKGNAME}.git
cd ${PKGNAME}

# Update the PKGBUILD
makepkg -s
rm .SRCINFO
makepkg --printsrcinfo > .SRCINFO
git add PKGBUILD .SRCINFO
git commit -m "Update to $(cat PKGBUILD | grep pkgver= | cut -d '=' -f 2)"
git push
