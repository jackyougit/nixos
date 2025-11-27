{ ... }:

{
  programs.git = {
    enable = true;

    userName  = "Jack";
    userEmail = "me@jackrbyrne.com";

    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
