# apps/ssh/default.nix
_:

{
  programs.ssh = {
    enable = true;

    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/jack-github";
        identitiesOnly = true;
      };

      "opnsense" = {
      	hostname ="opnsense.byrne.internal";
	user = "root";
	identityFile = "~/.ssh/opnsense_root";
	identitiesOnly = true;
	port = 22;
      };

      "dns" = {
      	hostname ="dns.byrne.internal";
	user = "jack";
	identityFile = "~/.ssh/jack";
	identitiesOnly = true;
	port = 22;
      };
    };
  };

  # Start an ssh-agent for your user
  services.ssh-agent.enable = true;
}
