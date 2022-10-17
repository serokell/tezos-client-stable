<!--
   - SPDX-FileCopyrightText: 2021 Oxhead Alpha
   - SPDX-License-Identifier: LicenseRef-MIT-OA
   -->
# Systemd units with Tezos binaries

<a name="ubuntu-and-fedora"></a>
## Systemd units on Ubuntu and Fedora

`tezos-node`, `tezos-accuser-<proto>`, `tezos-baker-<proto>`,
and `tezos-signer` packages have systemd files included to the
Ubuntu and Fedora packages.

Once you've installed one of these packages, you can run the service
using the following command:
```
systemctl start <package-name>.service
```
To stop the service run:
```
systemctl stop <package-name>.service
```

Each service has its configuration file located in `/etc/default`. Default
configurations can be found [here](../docker/package/defaults/).

Files created by the services will be located in `/var/lib/tezos/` by default.
`tezos-{accuser, baker}-<protocol>` services have a configurable
data directory.

`tezos-accuser` has a configurable node address, so that it can be used with both
remote and local node.

<a name="generic-linux"></a>
## Systemd units on other Linux systems

If you're not using Ubuntu or Fedora you can still construct systemd units for binaries
from scratch.

For this you'll need a `.service` file to define each systemd service.
The easiest way to get one is to generate one with `docker` by running [`gen_systemd_service_file.py`](../gen_systemd_service_file.py).

First you'll need to set the `OCTEZ_VERSION` env variable, e.g.:
```sh
export OCTEZ_VERSION="v14.1"
```
Then you can use the script, specifying the binary name as an argument, e.g.:
```
./gen_systemd_service_file.py tezos-node
# or
./gen_systemd_service_file.py tezos-baker-013-PtJakart
```
After that you'll have `.service` files in the current directory.

Apart from these `.service` files you'll need the services' startup scripts and default
configuration files, they can be found in the [`scripts`](../docker/package/scripts) and
[`defaults`](../docker/package/defaults) folders respectively.

## Systemd units on WSL

Unfortunately, `systemd` is not officially supported on WSL.

However, there are several unofficial workarounds for it and some have been known to work with `tezos-packaging`'s units.

If you are successfully running a distro on WSL with `systemd`, the documentation above should apply to you too.

## Multiple similar systemd services

It's possible to run multiple similar services, e.g. two `tezos-node`s that run different
networks.

`tezos-node` packages provide multiple services out of the box:
`tezos-node-jakartanet`, and `tezos-node-mainnet` that run
`jakartanet` and `mainnet` networks respectively.

In order to start it run:
```
systemctl start tezos-node-<network>
```

Also, there are `tezos-node-<network>` binary aliases that are equivalent to
```
TEZOS_NODE_DIR="<DATA_DIR from tezos-node-<network>.service>" tezos-node
```

In addition to node services where the config is predefined to a specific network
(e.g. `tezos-node-mainnet` or `tezos-node-jakartanet`), it's possible to run `tezos-node-custom`
service and provide a path to the custom node config file via the
`CUSTOM_NODE_CONFIG` variable in the `tezos-node-custom.service` file.

Another case for running multiple similar systemd services is when one wants to have
multiple daemons that target different protocols.
Since daemons for different protocols are provided in the different packages, they will
have different service files. The only thing that needs to be changed is config file.
One should provide desired node address, data directory for daemon files and node directory
(however, this is the case only for baker daemon).

`tezos-signer` package provides four services one for each mode in which signing daemon can run:
* Over TCP socket (`tezos-signer-tcp.service`).
* Over UNIX socker (`tezos-signer-unix.service`).
* Over HTTP (`tezos-signer-http.service`).
* Over HTTPS (`tezos-signer-https.service`)
Each signer service has dedicated config file in e.g. `/etc/default/tezos-signer-{mode}`.
