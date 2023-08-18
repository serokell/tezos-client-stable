# SPDX-FileCopyrightText: 2021 Oxhead Alpha
# SPDX-License-Identifier: LicenseRef-MIT-OA

# This script is used in octez-binaries.nix and isn't supposed to be run
# other way than 'nix-build octez-binaries.nix'
machine.succeed('export OCTEZ_LOG="* -> warning"')
machine.succeed("mkdir client-dir")
machine.succeed("mkdir signer-dir")
with subtest("run binaries with --help"):
    for b in binaries:
        machine.succeed(b + " --help")


machine.succeed(f"{octez_client} -d client-dir gen keys baker")


def pkill_background(binary):
    machine.succeed("pkill " + binary)


def run_node(network, use_tls):
    machine.succeed("mkdir node-dir")
    tls_args = " --rpc-tls=" + host_cert + "," + host_key + " " if use_tls else " "
    machine.succeed(f"{octez_node} config init --data-dir node-dir --network {network}")
    machine.succeed(f"{octez_node} identity generate 1 --data-dir node-dir")
    machine.succeed(
        f"{octez_node} run --data-dir node-dir --rpc-addr :8732 "
        + tls_args
        + "--no-bootstrap-peers --network "
        + network
        + " >/dev/null &"
    )
    tls_endpoint = (
        " --endpoint https://localhost:8732/ "
        if use_tls
        else " --endpoint http://localhost:8732/ "
    )
    machine.wait_until_succeeds(
        octez_client + tls_endpoint + "rpc get chains/main/blocks/head/"
    )


def run_node_with_daemons(network, use_tls):
    run_node(network, use_tls)
    tls_endpoint = (
        " --endpoint https://localhost:8732/ "
        if use_tls
        else " --endpoint http://localhost:8732/ "
    )
    machine.succeed(
        f"{octez_baker} -d client-dir"
        + tls_endpoint
        + "run with local node node-dir baker --liquidity-baking-toggle-vote on >/dev/null &"
    )
    machine.succeed(octez_accuser + tls_endpoint + "-d client-dir run >/dev/null &")


def kill_node_with_daemons():
    pkill_background("octez-accuser")
    pkill_background("octez-baker")
    pkill_background("octez-node")
    # Waiting node process to be killed before cleaning up to avoid race-conditions
    machine.wait_until_fails("pgrep octez-node")
    machine.succeed("rm -rf node-dir")


def test_node_with_daemons_scenario(network, use_tls=False):
    tls_endpoint = (
        " --endpoint https://localhost:8732/ "
        if use_tls
        else " --endpoint http://localhost:8732/ "
    )
    run_node_with_daemons(network, use_tls)
    machine.succeed(
        octez_admin_client + tls_endpoint + "rpc get chains/main/blocks/head/"
    )
    kill_node_with_daemons()


with subtest("run node with daemons on nairobinet"):
    test_node_with_daemons_scenario("nairobinet")

with subtest("run node with daemons on mainnet"):
    test_node_with_daemons_scenario("mainnet")

with subtest("run node with daemons using tls"):
    test_node_with_daemons_scenario("mainnet", use_tls=True)

with subtest("test remote signer"):
    machine.succeed(f"{octez_signer} -d signer-dir gen keys signer")
    signer_addr = machine.succeed(
        f'{octez_signer} -d signer-dir show address signer | tail -n +1 | head -n 1 | sed -e s/^"Hash: "//g'
    )
    machine.succeed(
        f"{octez_signer} -d signer-dir launch socket signer -a 127.0.0.1 -p 22000 >/dev/null &"
    )
    machine.succeed(
        f"{octez_client} -d client-dir import secret key remote-signer-tcp tcp://127.0.0.1:22000/{signer_addr}"
    )

with subtest("test encode and decode JSON"):
    machine.succeed(f"{octez_codec} encode timespan.system from 42.42")
    machine.succeed(f"{octez_codec} decode timespan.system from 404535c28f5c28f6")
