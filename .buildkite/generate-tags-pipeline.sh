#! /usr/bin/env nix-shell
#! nix-shell shell.nix -i bash

# SPDX-FileCopyrightText: 2022 TQ Tezos <https://tqtezos.com/>
#
# SPDX-License-Identifier: LicenseRef-MIT-TQ

# This script generates part of the .buildkite/pipeline-for-tags.yml config file
# by appending every step associated with bottle building to the steps defined there.

set -euo pipefail

ymlappend () {
    echo "$1" >> .buildkite/pipeline-for-tags.yml
}

# we don't bottle meta-formulas that contain only services
formulae=("tezos-accuser-011-PtHangz2")

# tezos-sapling-params is used as a dependency for some of the formulas
# so we handle it separately.
# We don't build the bottle for it because it is never updated over time.
ymlappend "
 - label: Install tezos-sapling-params
   key: install-tsp
   agents:
     queue: \"arm64-darwin\"
   commands:
   - brew install --formula ./Formula/tezos-sapling-params.rb"

n=0
for f in "${formulae[@]}"; do
  n=$((n+1))
  ymlappend "
 - label: Build $f bottle for Big Sur arm64
   key: build-bottle-$n
   agents:
     queue: \"arm64-darwin\"
   commands:
   - ./scripts/build-one-bottle.sh \"$f\"
   artifact_paths:
     - '*.bottle.*'"
done

ymlappend "
 - label: Uninstall tezos-sapling-params
   key: uninstall-tsp
   depends_on:"

for ((i=1; i<=n; i++)); do
  ymlappend "   - build-bottle-$i"
done

ymlappend "   agents:
     queue: \"arm64-darwin\"
   commands:
   - brew uninstall ./Formula/tezos-sapling-params.rb"
