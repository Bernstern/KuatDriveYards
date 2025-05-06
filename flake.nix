{
  description = "macOS configuration with Nix Flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, darwin, home-manager, ... }:
    let
      system = "x86_64-darwin";
      username = "bernstern"; 
      hostname = "Prosecutor"; 
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      darwinConfigurations.${hostname} = darwin.lib.darwinSystem {
        inherit system;
        modules = [
          {
            # Basic darwin configuration
            networking.hostName = hostname;
            
            # User configuration
            users.users.${username} = {
              home = "/Users/${username}";
            };

            # Disable nix-darwin's Nix management
            nix.enable = false;
            environment.etc."shells".enable = false;
            
            system.stateVersion = 4;

            nix.settings.experimental-features = [ "nix-command" "flakes" ];

            homebrew = {
              enable = true;
              onActivation = {
                autoUpdate = true;
                cleanup = "zap";
              };
              global = {
                brewfile = true;
              };
              casks = [
                "nikitabobko/tap/aerospace"
                "shortcat"
                "iterm2"
                "signal"
              ];
              taps = [
                "nikitabobko/tap"
              ];
              brews = [
                "uv"
                "fish"  
              ];
            };

            # Dock setup
            system.defaults.dock = {
                autohide = false;
                tilesize = 36;  
                magnification = false;  
            };

            # Use launchd to auto-start applications
            launchd.user.agents = {
              aerospace = {
                serviceConfig = {
                  ProgramArguments = [
                    "/Applications/Aerospace.app/Contents/MacOS/Aerospace"
                  ];
                  KeepAlive = true;
                  RunAtLoad = true;
                  StandardOutPath = "/tmp/aerospace.log";
                  StandardErrorPath = "/tmp/aerospace.error.log";
                };
              };
              
              shortcat = {
                serviceConfig = {
                  ProgramArguments = [
                    "/Applications/Shortcat.app/Contents/MacOS/Shortcat"
                  ];
                  KeepAlive = true;
                  RunAtLoad = true;
                  StandardOutPath = "/tmp/shortcat.log";
                  StandardErrorPath = "/tmp/shortcat.error.log";
                };
              };
            };
          }
          
          home-manager.darwinModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home.nix;
          }
        ];
      };
      
      # Add a formatter for 'nix fmt'
      formatter.${system} = pkgs.nixpkgs-fmt;
    };
}