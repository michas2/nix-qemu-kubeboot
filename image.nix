import <nixpkgs/nixos/lib/make-disk-image.nix> {
  inherit (import <nixpkgs> {}) pkgs lib;
  inherit (import <nixpkgs/nixos> { configuration = import ./master-config.nix;}) config;
  diskSize = 8192;
  format   = "qcow2";
}
