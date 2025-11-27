{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;

    # You can expand this later with plugins/config/etc.
    # For now it just enables nvim.
  };
}
