_:

{
  programs.kitty = {
    enable = true;

    settings = {
      # Let kitty use your configured login shell automatically
      confirm_os_window_close = "0";
      font_family = "JetBrainsMono Nerd Font";
      font_size = "11.0";
    };
  };
}
