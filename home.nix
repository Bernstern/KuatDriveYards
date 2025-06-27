{ config, pkgs, ... }:

{
  home.stateVersion = "22.11";
  programs.git.enable = true;
  home.packages = with pkgs; [
    htop
    wget
    vim
    docker
    docker-compose
  ];


  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "ls -la";
      rebuild = "darwin-rebuild switch --flake /Users/bernstern/projects/nixos/nixpkgs#Prosecutor";
    };
    interactiveShellInit = ''
      set fish_greeting
      fish_add_path ~/.nix-profile/bin
      fish_add_path /nix/var/nix/profiles/default/bin
      fish_add_path /run/current-system/sw/bin
      fish_add_path ~/.local/bin

      # Initialize Fisher
      if not functions -q fisher
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
      end

      # Install nvm.fish if not already installed
      if not functions -q nvm
        fisher install jorgebucaran/nvm.fish
      end

      # Setup nvm to use node 22 (suppress output)
      if not test -d ~/.nvm/versions/node/ || test (count ~/.nvm/versions/node/*) -eq 0
        nvm install lts/jod >/dev/null 2>&1
      end
      nvm use lts/jod >/dev/null 2>&1

      # Install Claude CLI if not already installed
      if not command -q claude
        npm install -g @anthropic-ai/claude-code
      end
    '';
  };
  
}