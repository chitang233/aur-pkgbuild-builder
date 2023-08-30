#!/usr/bin/env bash
set -e

export SSH_PRIVATE_KEY=$INPUT_DEPLOY_KEY
export PKGNAME=$INPUT_PACKAGE_NAME

# Install dependencies
pacman -Syu --noconfirm git openssh base-devel

# Install paru
pacman-key --init
pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 3056513887B78AEB
pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' --noconfirm
echo "[chaotic-aur]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf
pacman -Sy

# Create a user
useradd -G wheel -m -s /bin/bash builder
echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Run as builder
su -m builder -c "bash /build.sh"