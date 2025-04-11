{ config, pkgs, ... }:

{
  home.stateVersion = "22.11";
  programs.zsh.enable = true;
  programs.git.enable = true;
  home.packages = with pkgs; [
    htop
  ];
}