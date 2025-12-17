{ pkgs, ... }:

{
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
      wp      = "plasma-span-set";
      wplist  = "ls -l ~/nixos/wallpapers/*.jpg 2>/dev/null";
    };

    history.size = 1000;
  };
}
