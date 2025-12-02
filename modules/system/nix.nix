{ config, pkgs, ... }:

{
  # Enable new Nix CLI and flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
}
