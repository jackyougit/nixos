{ config, pkgs, ... }:

{
  # System-wide zsh support
  programs.zsh.enable = true;

  # Your user account
  users.users.jack = {
    isNormalUser = true;
    extraGroups  = [ "wheel" "libvirtd" "networkmanager" ];
    shell        = pkgs.zsh;
    packages     = with pkgs; [
      tree
    ];
  };
}
