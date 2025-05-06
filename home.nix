{ config, pkgs, ... }:

{
  home.stateVersion = "22.11";
  programs.git.enable = true;
  home.packages = with pkgs; [
    htop
    wget
    vim
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
    '';
  };
  
}