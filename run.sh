#!/usr/bin/env bash

##############################################################
# find directory of this script
##############################################################
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

##############################################################
# stop on error
##############################################################
set -eu

master(){
  ##############################################################
  # build image
  ##############################################################
  nix-build image.nix

  ##############################################################
  # make a writable copy of the image
  ##############################################################
  file=/tmp/nixos.qcow2
  cp result/nixos.qcow2 $file
  chmod +w $file

  ##############################################################
  # generate a random MAC address
  ##############################################################
  printf -v MAC "52:54:%02x:%02x:%02x:%02x" $(( $RANDOM & 0xff)) $(( $RANDOM & 0xff )) $(( $RANDOM & 0xff)) $(( $RANDOM & 0xff ))

  ##############################################################
  # run the image
  ##############################################################
  qemu-system-x86_64 -enable-kvm -m 4G -smp 2 \
   -drive format=qcow2,file=$file \
   -device virtio-net,netdev=mesh,addr=5,mac=$MAC -netdev socket,mcast=230.0.0.1:1234,id=mesh \
   -device virtio-net,netdev=user,addr=6          -netdev user,id=user
}

slave(){
  ##############################################################
  # run a netboot client
  ##############################################################
  qemu-system-x86_64 -enable-kvm -m 4G -smp 2 -boot n \
    -device virtio-net,netdev=mesh,addr=5 -netdev socket,mcast=230.0.0.1:1234,id=mesh
}


##############################################################
# add "slave" to start a slave instead of the netboot master
##############################################################
if [ "${1:-x}" = "slave" ]; then
  slave
else
  master
fi
