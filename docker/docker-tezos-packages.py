#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2022 Oxhead Alpha
# SPDX-License-Identifier: LicenseRef-MIT-OA

import os
import sys
import shlex
import subprocess
from package.packages import packages
from package.package_generator import parser
from package.package_generator import output_dir as container_output_dir

ubuntu_versions = [
    "bionic",  # 18.04
    "focal",  # 20.04
    "jammy",  # 22.04
]

fedora_versions = [
    "35",
    "36",
]


def check_call(cmd):
    return subprocess.check_call(shlex.split(cmd))


def call(cmd):
    return subprocess.call(shlex.split(cmd))


def get_proc_output(cmd):
    if sys.version_info.major == 3 and sys.version_info.minor < 7:
        return subprocess.run(shlex.split(cmd), stdout=subprocess.PIPE)
    else:
        return subprocess.run(shlex.split(cmd), capture_output=True, text=True)


def get_packages_to_build(arg):
    if arg:
        for pkg in arg:
            if not packages.get(pkg, None):
                raise Exception("Unknown package name.")
        return {key: packages[key] for key in arg}
    return packages


if os.getenv("USE_PODMAN", None):
    virtualisation_engine = "podman"
else:
    virtualisation_engine = "docker"

parser.add_argument(
    "--output-dir",
    help="provide a directory to place the built packages",
    default=f"{os.path.join(os.getcwd(), 'out')}",
    type=os.path.abspath,
)
args = parser.parse_args()

docker_volumes = ""

if args.binaries_dir:
    binaries_dir_name = os.path.basename(args.binaries_dir)
    docker_volumes = (
        f"-v {args.binaries_dir}:/tezos-packaging/docker/{binaries_dir_name}"
    )
else:
    binaries_dir_name = None

target_os = args.os

if target_os == "ubuntu":
    if args.distributions:
        for dist in args.distributions:
            if dist not in ubuntu_versions:
                raise Exception(
                    f"Distribution {dist} is not supported for {target_os}."
                )
        distributions = args.distributions
    else:
        distributions = ubuntu_versions
else:
    if args.distributions:
        for dist in args.distributions:
            if dist not in fedora_versions:
                raise Exception(
                    f"Distribution {dist} is not supported for {target_os}."
                )
        distributions = args.distributions
    else:
        distributions = ["native"]

octez_version = os.getenv("OCTEZ_VERSION", None)

if not octez_version:
    raise Exception("Environment variable OCTEZ_VERSION does not set.")

# prebuild docker image before using containers
check_call(
    f"""
{virtualisation_engine}
build -t tezos-{target_os}
-f docker/package/Dockerfile-{target_os} .
"""
)


# enclose defined above variables to shorten argument list
def build_packages(pkgs, distros):

    cmd_args = " ".join(
        [
            f"--os {target_os}",
            f"--binaries-dir {binaries_dir_name}" if binaries_dir_name else "",
            f"--sources {args.sources}" if args.sources else "",
            f"--type {args.type}",
            f"--distributions {' '.join(distros)}",
            f"--packages {' '.join(pkgs)}",
        ]
    )

    container_create_args = (
        "--cap-add SYS_ADMIN" if target_os == "fedora" and args.distributions else ""
    )

    container_id = get_proc_output(
        f"""
    {virtualisation_engine}
    create {docker_volumes}
    {container_create_args}
    --env OCTEZ_VERSION={octez_version}
    --env OPAMSOLVERTIMEOUT=900
    -t tezos-{target_os} {cmd_args}
    """
    ).stdout.strip()

    exit_code = call(f"{virtualisation_engine} start -a {container_id}")

    os.makedirs(args.output_dir, exist_ok=True)

    call(
        f"""
    {virtualisation_engine} cp
    {container_id}:/tezos-packaging/docker/{container_output_dir} .
    """
    )

    call(f"{virtualisation_engine} rm -v {container_id}")

    if exit_code:
        print("Unrecoverable error occured.")
        sys.exit(exit_code)


packages_to_build = get_packages_to_build(args.packages)

build_packages(packages_to_build.keys(), distributions)
