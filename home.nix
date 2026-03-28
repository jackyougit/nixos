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

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      SUDO_EDITOR = "nvim";
    };

    sessionPath = [
      "$HOME/.local/bin"
    ];

    packages = with pkgs; [
      tree
      python3
      pipx

      (writeShellApplication {
        name = "ns";
        runtimeInputs = [
          fzf
          nix-search-tv
        ];
        text = builtins.readFile "${nix-search-tv.src}/nixpkgs.sh";
      })
    ];
  };
}
