{ pkgs, ... }:
{
  # Allow YubiKey to be accessed without root
  services.udev.packages = [ pkgs.yubikey-personalization ];

  # Tools for managing the YubiKey
  environment.systemPackages = with pkgs; [
    yubikey-manager        # ykman CLI
    yubikey-personalization # ykpersonalize
    yubico-piv-tool        # for PIV slot if we ever need it
    pinentry-qt            # for SSH/GPG passphrase prompts (or pinentry-curses for tty)
  ];

  # PCSC daemon for smartcard mode (used by some YubiKey features)
  services.pcscd.enable = true;
}
