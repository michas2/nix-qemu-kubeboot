{ config, lib, pkgs, ... }:

{
  imports = [
    ./qemu.nix
    ./netboot.nix
  ];

  netboot = {
    network.wan="ens6";
    network.lan="ens5";
    image=./worker-config.nix;
  };

  users.users.root.password="root";
  i18n.consoleKeyMap = "dvorak";
  environment.systemPackages = [ pkgs.tcpdump ];

  services.kubernetes = {
    roles = ["master"];
  };
}
