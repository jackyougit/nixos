# modules/system/ssh-ca.nix
{ ... }:
{
  programs.ssh.knownHosts = {
    "byrne-ssh-ca" = {
      certAuthority = true;
      hostNames = [
        "*.byrne.internal"
        "172.16.10.*"
        "172.16.20.*"
        "172.16.30.*"
        "172.16.40.*"
        "172.16.50.*"
        "pi"
        "opnsense"
        "truenas"
      ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGXI92IWkg7V2ywGCdrg0LiH+dIbyCNU2RxpEikO+UdU byrne ssh ca 2026-05-01";
    };
  };
}
