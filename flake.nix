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

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      firefox-addons,
      ...
    }:
    let
      system = "x86_64-linux";
      username = "jack";
      hostName = "jack-pc";
      configRepo = "/home/${username}/nixos";

      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # This makes `nix fmt` work in this repo.
      formatter.${system} = pkgs.nixfmt-rfc-style;

      devShells.${system}.default = pkgs.mkShellNoCC {
        packages = with pkgs; [
          nixfmt-rfc-style
          deadnix
          statix
        ];
      };
      # These run when you use `nix flake check`.
      checks.${system} = {
        deadnix =
          pkgs.runCommand "deadnix-check"
            {
              nativeBuildInputs = [ pkgs.deadnix ];
            }
            ''
              cd ${self}
              deadnix --fail .
              mkdir -p "$out"
            '';

        statix =
          pkgs.runCommand "statix-check"
            {
              nativeBuildInputs = [ pkgs.statix ];
            }
            ''
              cd ${self}
              statix check . --ignore hardware-configuration.nix
              mkdir -p "$out"
            '';
      };

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
                inherit
                  username
                  hostName
                  configRepo
                  firefox-addons
                  ;
              };
              users.${username} = import ./home.nix;
            };
          }
        ];
      };
    };
}
