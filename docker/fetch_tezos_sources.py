#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2023 Oxhead Alpha
# SPDX-License-Identifier: LicenseRef-MIT-OA

import subprocess
import os
import re
import shutil

octez_version = os.getenv("OCTEZ_VERSION", None)

if not octez_version:
    raise Exception("Environment variable OCTEZ_VERSION is not set.")

subprocess.run(
    [
        "git",
        "clone",
        "--branch",
        octez_version,
        "https://gitlab.com/tezos/tezos.git",
        "--depth",
        "1",
    ]
)

shutil.rmtree(os.path.join("tezos", ".git"))

subprocess.run(["git", "clone", "https://gitlab.com/tezos/opam-repository.git"])

with open("get_opam_tag.sh", "w") as f:
    f.write("source ./tezos/scripts/version.sh; echo $opam_repository_tag")

opam_repository_tag = (
    subprocess.run(["bash", "get_opam_tag.sh"], stdout=subprocess.PIPE)
    .stdout.decode()
    .strip()
)

os.chdir("opam-repository")
subprocess.run(["git", "checkout", opam_repository_tag])
subprocess.run(["rm", "-rf", ".git"])
subprocess.run(["rm", "-r", "zcash-params"])
subprocess.run(["opam", "admin", "cache"])
