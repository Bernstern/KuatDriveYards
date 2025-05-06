# NIXOS Setup

## Install

```bash
curl -L https://nixos.org/nix/install | sh
```

## First time setup

```bash
darwin-rebuild switch --flake .#Prosecutor

# We only have to do this once because of #security
chsh -s $(which fish)
```

