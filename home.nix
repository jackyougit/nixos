{ config, pkgs, firefox-addons, ... }:

{
  imports = [
    ./apps/firefox
    ./apps/neovim
    ./apps/kitty
    ./apps/git
    ./apps/zsh
    ./apps/ssh
    ./apps/wine
    ./apps/plasma
    #./apps/hyprland
    #./apps/waybar
    #./apps/swaync
  ];

  home.username = "jack";
  home.homeDirectory = "/home/jack";
  home.stateVersion = "25.05";

  home.sessionVariables = {
    EDITOR      = "nvim";
    VISUAL      = "nvim";
    SUDO_EDITOR = "nvim";
  };

  home.packages = with pkgs; [
    # ns helper script
    (pkgs.writeShellApplication {
      name = "ns";
      runtimeInputs = with pkgs; [
        fzf
        nix-search-tv
      ];
      text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
    })

    # Wallpaper + notifications
    swww
    libnotify   # gives you `notify-send`
  ];

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

     history.size = 1000;
  };
}

