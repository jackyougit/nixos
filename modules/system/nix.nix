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

  # Be honest about the policy on this host.
  # Steam is unfree, so a fake "only allow one unfree package" setup would just
  # be misleading unless you carefully enumerate every required package.
  nixpkgs.config.allowUnfree = true;
}
