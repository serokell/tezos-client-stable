#! /usr/bin/env python3

# SPDX-FileCopyrightText: 2020 TQ Tezos <https://tqtezos.com/>
#
# SPDX-License-Identifier: LicenseRef-MIT-TQ

# Note: if you modify this file, check if its usage in docs/systemd.md
# needs to be updated too.

from docker.package import *
import sys

if len(sys.argv) > 1:
    binary_name = sys.argv[1]
    for _, package in packages.items():
        if binary_name == package.name:
            for systemd_unit in package.systemd_units:
                if systemd_unit.suffix is None:
                    out_name = f"{package.name}.service"
                else:
                    out_name = f"{package.name}-{systemd_unit.suffix}.service"
                print_service_file(systemd_unit.service_file, out_name)
