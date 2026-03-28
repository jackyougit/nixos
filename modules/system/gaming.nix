_:

{
  programs.steam = {
    enable = true;

    # Keep only what you actually use
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;

    # Turn this on only if you actually host dedicated servers
    dedicatedServer.openFirewall = false;
  };

  programs.gamemode.enable = true;
  hardware.steam-hardware.enable = true;
}
