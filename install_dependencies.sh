#!/usr/bin/env bash

printf "Installing xcode cli dependencies...\n"
xcode-select --install

printf "Installing brew...\n"
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

printf "Installing nixos...\n"
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate
