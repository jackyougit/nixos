{
  description = "Jack's NixOS configuration";

  inputs = {
    # One primary nixpkgs input for the whole system
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    # Keep Home Manager on the matching release line
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Keep this because your Firefox module uses it
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, firefox-addons, ... }:
    let
      system = "x86_64-linux";
      username = "jack";
      hostName = "jack-pc";
      configRepo = "/home/${username}/nixos";
    in
    {
      nixosConfigurations.${hostName} = nixpkgs.lib.nixosSystem {
        inherit system;

        # Shared values passed into NixOS modules
        specialArgs = {
          inherit username hostName configRepo;
        };

        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";

              # Shared values passed into Home Manager modules
              extraSpecialArgs = {
                inherit username hostName configRepo firefox-addons;
              };

              users.${username} = import ./home.nix;
            };
          }
        ];
      };
    };
}
