{
  description = "Jack's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    # Newer channel for specific packages
    nixpkgs-25_11.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-25_11, home-manager, firefox-addons, plasma-manager, ... }:
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;

    # Allow ONLY this unfree package
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "fastmail-desktop"
    ];

    # Import 25.11 with the unfree predicate applied
    pkgs25_11 = import nixpkgs-25_11 {
      inherit system;
      config.allowUnfreePredicate = allowUnfreePredicate;
    };

    # Overlay: expose fastmail-desktop into your normal pkgs
    fastmailOverlay = final: prev: {
      fastmail-desktop = pkgs25_11.fastmail-desktop;
    };
  in
  {
    nixosConfigurations.jack-pc = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        # Enable overlay + (optional) also allow the same predicate on your main pkgs
        ({ ... }: {
          nixpkgs.overlays = [ fastmailOverlay ];
          nixpkgs.config.allowUnfreePredicate = allowUnfreePredicate;
        })

        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;

            sharedModules = [
              plasma-manager.homeModules.plasma-manager
            ];

            users.jack = import ./home.nix;
            backupFileExtension = "backup";

            extraSpecialArgs = {
              inherit firefox-addons;
            };
          };
        }
      ];
    };
  };
}

