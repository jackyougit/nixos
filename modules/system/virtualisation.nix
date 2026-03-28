{ username, ... }:

{
  virtualisation.libvirtd = {
    enable = true;

    qemu = {
      # Safer default
      runAsRoot = false;
    };
  };

  programs.virt-manager.enable = true;

  # This gives broad control over the system libvirt daemon.
  # Keep it only if you actively use virt-manager or virsh on this machine.
  users.users.${username}.extraGroups = [ "libvirtd" ];
}
