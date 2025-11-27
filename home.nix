{ config, pkgs, firefox-addons, ... }:

{
  
  imports = [
    ./apps/firefox
    ./apps/neovim
    ./apps/kitty
    ./apps/git
    ./apps/zsh
    ./apps/ssh
  ];

  home.username = "jack";
  home.homeDirectory = "/home/jack";
  home.stateVersion = "25.05";

  home.sessionVariables = {
    EDITOR	= "nvim";
    VISUAL	= "nvim";
    SUDO_EDITOR	= "nvim";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [ "git" "z" "sudo" ];
    };

    shellAliases = {
      ls      = "ls -l";
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#jack-pc";
      edit    = "sudo -e";
      vim     = "nvim";
    };

    history.size = 1000;
  };
}
