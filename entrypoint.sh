#!/usr/bin/env bash
set -e

export SSH_PRIVATE_KEY=$INPUT_DEPLOY_KEY
export PKGNAME=$INPUT_PACKAGE_NAME

# Install dependencies
pacman -Syu --noconfirm git openssh base-devel

# Create a user
useradd -G wheel -m -s /bin/bash builder
echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Run as builder
su -m builder -c "bash /build.sh"