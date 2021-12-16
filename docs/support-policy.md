<!--
   - SPDX-FileCopyrightText: 2021 TQ Tezos <https://tqtezos.com/>
   -
   - SPDX-License-Identifier: LicenseRef-MIT-TQ
   -->
# Packages support policy

`tezos-packaging` provides packages for Ubuntu, Fedora and macOS for each stable and release-candidate
version of the Octez.

This document targets to explain which versions of the aforementioned OSes are targeted
by our packages.

## Ubuntu packages

We provide support for all LTSes supported by Canonical:
* 18.04 LTS (Bionic Beaver)
* 20.04 LTS (Focal Fossa)

Also, we provide support for non-LTS versions on request from the users.
E.g. 21.04 (Hirsute Hippo) support was requested in [#212](https://github.com/serokell/tezos-packaging/issues/212).

There are packages for `arm64` and `amd64` architectures.

## Fedora packages

<!-- TODO: mention that we support all maintained versions once TODO below is resolved -->
We provide support for the following Fedora versions:
* Fedora 34
<!-- * Fedora 35 TODO: uncomment once we're done with Fedora 35 support -->

There are packages for `x86_64` and `aarch64` architectures.

## macOS brew formulae

Brew formulae provided by `tezos-packaging` support all maintained macOS versions.

Unfortunately, an ability to provide pre-compiled brew bottles for formulae has
a hard dependency on the available build infrastructure. At the moment, the only macOS
versions for which we provide brew bottles are Big Sur (both `x86_64` and `arm64`) and Catalina.
