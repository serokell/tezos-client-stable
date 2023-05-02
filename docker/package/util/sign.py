#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2023 Oxhead Alpha
# SPDX-License-Identifier: LicenseRef-MIT-OA

import os
import sys
import shutil
import argparse
import subprocess
from dataclasses import dataclass
from typing import Optional, List

sys.path.append("docker")
from package.util.sign_common import *
from package.util.sign_fedora import sign_fedora
from package.util.sign_ubuntu import sign_ubuntu


def main(args: Optional[Arguments] = None):

    if args is None:
        args = fill_args(parser.parse_args())

    targets = ["ubuntu", "fedora"] if args.os is None else [args.os]

    for target in targets:
        if target == "ubuntu":
            sign_ubuntu(args)
        elif target == "fedora":
            sign_fedora(args)
        else:
            print(f"{target} target is not supported")


if __name__ == "__main__":
    main()
