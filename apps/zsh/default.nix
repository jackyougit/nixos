{ hostName, configRepo, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [
        "git"
        "z"
        "sudo"
      ];
    };

    shellAliases = {
      ls = "ls -l";
      ssh = "kitten ssh";

      # Apply the current pinned system
      rebuild = "sudo nixos-rebuild switch --flake ${configRepo}#${hostName}";

      # Update flake inputs first, then rebuild
      sysupgrade = "nix flake update --flake ${configRepo} && sudo nixos-rebuild switch --flake ${configRepo}#${hostName}";

      edit = "sudo -e";

      wp = "plasma-span-set";
      wplist = "ls -l ${configRepo}/wallpapers/*.jpg 2>/dev/null";
    };

    history.size = 1000;
  };
}
