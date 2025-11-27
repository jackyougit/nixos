{ config, pkgs, ... }:

{
  # System-wide zsh support
  programs.zsh.enable = true;

  # Your user account
  users.users.jack = {
    isNormalUser = true;
    extraGroups  = [ "wheel" ];   # sudo via wheel
    shell        = pkgs.zsh;      # login shell
    packages     = with pkgs; [
      tree
    ];
  };
}
