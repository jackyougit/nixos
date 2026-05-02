# modules/system/yubikey.nix
{ pkgs, ... }:
{
  # Smartcard daemon needed for some YubiKey applications (PIV, OpenPGP)
  services.pcscd.enable = true;

  # udev rules so YubiKey is accessible without sudo
  services.udev.packages = [ pkgs.yubikey-personalization ];

  # User must be in plugdev group for YubiKey access (NixOS handles this via udev,
  # but adding explicitly for clarity if other tools need it)
  users.groups.plugdev = { };

  # System packages for YubiKey management
  environment.systemPackages = with pkgs; [
    yubikey-manager           # ykman CLI for managing FIDO2, OATH, PIV apps
    yubikey-personalization   # ykpersonalize for OTP slots
    yubico-piv-tool           # yubico-piv-tool for PIV slot management
    libfido2                  # FIDO2 library
    pinentry-qt               # graphical PIN prompts (Qt, works in KDE/GNOME/etc)
    pinentry-curses           # terminal PIN prompts (works in tty)
  ];
}
