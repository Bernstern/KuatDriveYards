{
  description = "Bernstern's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, ... }:
    let
      system = "x86_64-darwin";
      username = "bernstern";
      hostname = "prosecutor";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      darwinConfigurations.${hostname} = darwin.lib.darwinSystem {
        inherit system;
        modules = [
          {
            nixpkgs.hostPlatform = system;
            users.users.${username} = {
              name = username;
              home = "/Users/${username}";
            };
            services.nix-daemon.enable = true;
            programs.zsh.enable = true;
            nix.settings.experimental-features = "nix-command flakes";
            environment.systemPackages = with pkgs; [
              vim
              git
            ];
            system.stateVersion = 4;
            security.pam.enableSudoTouchIdAuth = true;
          }
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home.nix;
          }
        ];
      };
      packages.${system}.default = pkgs.hello;
    };
}
