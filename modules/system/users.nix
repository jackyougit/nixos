{ pkgs, username, ... }:

{
  # Required so zsh can be used as a login shell
  programs.zsh.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.zsh;

    # Keep base user groups narrow.
    # Higher-privilege groups belong in the module that needs them.
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };
}
