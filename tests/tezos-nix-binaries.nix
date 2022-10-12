# SPDX-FileCopyrightText: 2021 Oxhead Alpha
# SPDX-License-Identifier: LicenseRef-MIT-OA
{ nixpkgs, pkgs, ... }:
let
  inherit (pkgs) system;
  inherit (pkgs.octezPackages) octez-client tezos-admin-client octez-node octez-signer octez-codec
    octez-accuser-PtKathma octez-baker-PtKathma;
in import "${nixpkgs}/nixos/tests/make-test-python.nix" ({ ... }:
{
  nodes.machine = { ... }: {
    virtualisation.memorySize = 1024;
    virtualisation.diskSize = 1024;
    environment.systemPackages = with pkgs; [
      libev
    ];
    security.pki.certificateFiles = [ ./ca.cert ];
    environment.sessionVariables.LD_LIBRARY_PATH =
      [ "${pkgs.ocamlPackages.hacl-star-raw}/lib/ocaml/4.12.0/site-lib/hacl-star-raw" ];
  };

  testScript = ''
    octez_accuser = "${octez-accuser-PtKathma}/bin/octez-accuser-PtKathma"
    tezos_admin_client = "${tezos-admin-client}/bin/tezos-admin-client"
    octez_baker = "${octez-baker-PtKathma}/bin/octez-baker-PtKathma"
    octez_client = (
        "${octez-client}/bin/octez-client"
    )
    octez_node = "${octez-node}/bin/octez-node"
    octez_signer = (
        "${octez-signer}/bin/octez-signer"
    )
    octez_codec = "${octez-codec}/bin/octez-codec"
    openssl = "${pkgs.openssl.bin}/bin/openssl"
    host_key = "${./host.key}"
    host_cert = "${./host.cert}"
    binaries = [
        octez_accuser,
        tezos_admin_client,
        octez_baker,
        octez_client,
        octez_node,
        octez_signer,
        octez_codec,
    ]
    ${builtins.readFile ./test_script.py}'';
}) { inherit pkgs system; }
