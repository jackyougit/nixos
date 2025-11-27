# apps/ssh/default.nix
{ pkgs, ... }:

{
  programs.ssh = {
    enable = true;

    matchBlocks = {
      "github.com" = {
        hostname       = "github.com";
        user           = "git";
        identityFile   = "~/.ssh/jack-github";
        identitiesOnly = true;
      };
    };
  };

  # Start an ssh-agent for your user
  services.ssh-agent.enable = true;
}

