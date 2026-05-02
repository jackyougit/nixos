{ inputs, ... }:

{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # Safe quality-of-life optimisation
      auto-optimise-store = true;
      substituters = [ "https://claude-code.cachix.org" ];
      trusted-public-keys = [
        "claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk="
      ];
    };
  };

  nixpkgs.config = {
    # Steam already means this host uses unfree packages
    allowUnfree = true;

    # Google Earth Pro is currently flagged insecure in nixpkgs
    permittedInsecurePackages = [
      "googleearth-pro-7.3.6.10201"
    ];
  };
}
