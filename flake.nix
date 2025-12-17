{
  description = "Jack's NixOS configuration";

  inputs = {

    nixpkgs.url = "nixpkgs/nixos-25.05";
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

  outputs = { self, nixpkgs, home-manager, firefox-addons, plasma-manager, ... }: {
    nixosConfigurations.jack-pc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
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

