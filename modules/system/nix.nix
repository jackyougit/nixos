_:

{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # Safe quality-of-life optimisation
      auto-optimise-store = true;
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
