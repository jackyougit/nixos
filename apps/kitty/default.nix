{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    settings = {
      shell = "${pkgs.zsh}/bin/zsh";
      confirm_os_window_close = "0";
      font_family = "JetBrainsMono Nerd Font";
      font_size   = "11.0";
    };
  };
}

