<!--
   - SPDX-FileCopyrightText: 2021 TQ Tezos <https://tqtezos.com/>
   -
   - SPDX-License-Identifier: LicenseRef-MIT-TQ
   -->
# Brew tap for macOS

If you're using macOS and `brew`, you can install Tezos binaries from the taps provided
by this repository. There are two taps: one for the latest stable release of Tezos and
one for the latest release candidate of Tezos.

In order to use latest stable version run the following:
```
brew tap serokell/tezos-packaging-stable https://github.com/serokell/tezos-packaging-stable.git
```

In order to use the latest release candidate version run the following:
```
brew tap serokell/tezos-packaging-rc https://github.com/serokell/tezos-packaging-rc.git
```

Once the desired tap is selected, you can install the chosen package, e.g.:
```
brew install tezos-client
```

For faster formulae installation we provide prebuilt bottles for some macOS versions in the releases.

## Sapling params on Macs with Apple CPUs

`tezos-sapling-params` formula provides `zcash-params` required by some Octez binaries.
Currently, on Macs with Apple CPUs brew installs `zcash-params` to the directory that isn't
checked by Octez binaries.

As a result, you may see the following error when trying to use Octez binary:
```
Failed to initialize Zcash parameters: cannot find Zcash params in any of:
...
You may download them using https://raw.githubusercontent.com/zcash/zcash/master/zcutil/fetch-params.sh
```

There is an [MR](https://gitlab.com/tezos/tezos/-/merge_requests/4609)
that targets to fix this, but in the meantime, an additional workaround is required.

In order to make `zcash-params` available for Octez binaries you can run the following command:
```
ln -s /opt/homebrew/Cellar/tezos-sapling-params/v8.2-3/share/zcash-params/ ~/.zcash-params
```

## Launchd background services on macOS.

IMPORTANT: All provided `launchd` services are run as a user agents, thus they're stopped after the logout.

`tezos-accuser-<proto>`, `tezos-baker-<proto>`, `tezos-endorser-<proto>` formulas
provide backround services for running the corresponding daemons.

Since `tezos-node` and `tezos-signer` need multiple services they are provided
in dedicated meta-formulas. These formulas don't install any binaries and only add
background services.

Formulas with `tezos-node` background services:
* `tezos-node-mainnet`
* `tezos-node-hangzhounet`

Formulas with `tezos-signer` background services:
* `tezos-signer-http`
* `tezos-signer-https`
* `tesos-signer-tcp`
* `tezos-signer-unix`

To start the service: `brew services start <formula>`.

To stop the service: `brew services stop <formula>`.

All of the brew services have various configurable env variables. These variables
can be changed in the corresponding `/usr/local/Cellar/tezos-signer-tcp/<version>/homebrew.mxcl.<formula>.plist`.
Once the configuration is updated, you should restart the service:
`brew services restart <formula>`.

## Building brew bottles

In order to build bottles with Tezos binaries run
`build-bottles.sh` script:
```
./scripts/build-bottles.sh
```

Note that this might take a while, because builds don't share common parts and for each binary
dependencies are compiled from scratch. Once the bottles are built, the corresponding sections in the
formulas should be updated. Also, bottles should be uploaded to the release artifacts.
