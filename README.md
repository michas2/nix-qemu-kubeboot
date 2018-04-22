A nix expression to create a netboot k8s cluster of qemu instances.

If you have a bunch of underutilized workstations, run a master VM using this image. Then run worker VMs on the other workstations.
The worker will simply netboot from the master, adding another node to the k8s cluster.

The `run.sh` script will help you with the correct qemu commands to run master and worker.

The main expression is `image.nix`, which creates the master image.
It takes its config from `master-config.nix`, which incudes a netboot server serving the image defined in `worker-config.nix`.



KNOWN BUGS:
* k8s nodes are not yet correctly connected
* nodes probably need more direct networking connection
* working completely in memory will probably not be enought
