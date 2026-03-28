{ ... }:

{
  programs.neovim = {
    enable = true;

    # This is cleaner than aliasing vim -> nvim in zsh
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
}
