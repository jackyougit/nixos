{ pkgs, username, ... }:

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
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.05";

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    SUDO_EDITOR = "nvim";
  };

  # This belongs at the user environment layer, not inside the Wine module
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.packages = with pkgs; [
    tree

    # Python tooling
    python3
    pipx

    # Small helper for searching nixpkgs interactively
    (writeShellApplication {
      name = "ns";
      runtimeInputs = [
        fzf
        nix-search-tv
      ];
      text = builtins.readFile "${nix-search-tv.src}/nixpkgs.sh";
    })
  ];
}
