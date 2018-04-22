{ config, lib, pkgs, ... }:

{
  imports = [
    ./qemu.nix
  ];

  users.users.root.password="root";
  i18n.consoleKeyMap = "dvorak";

  services.kubernetes = {
    roles = ["node"];
  };
}
