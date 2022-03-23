# SPDX-FileCopyrightText: 2022 Oxhead Alpha
# SPDX-License-Identifier: LicenseRef-MIT-OA

class TezosBaker012Psithaca < Formula
  @all_bins = []

  class << self
    attr_accessor :all_bins
  end
  homepage "https://gitlab.com/tezos/tezos"

  url "https://gitlab.com/tezos/tezos.git", :tag => "v12.0", :shallow => false

  version "v12.0-1"

  build_dependencies = %w[pkg-config autoconf rsync wget rustup-init]
  build_dependencies.each do |dependency|
    depends_on dependency => :build
  end

  dependencies = %w[gmp hidapi libev libffi tezos-sapling-params]
  dependencies.each do |dependency|
    depends_on dependency
  end
  desc "Daemon for baking"

  bottle do
    root_url "https://github.com/serokell/tezos-packaging/releases/download/#{TezosBaker012Psithaca.version}/"
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: "677a250ff4f37942b0d6a58ea9fa47cd3556fdcb838218839599bd1280f7dbca"
    sha256 cellar: :any, catalina: "d12dd5058d093e71449b2ffc11658b86429d844a732c8fec5a05b5172fd8dc6b"
    sha256 cellar: :any, arm64_big_sur: "8a04acb74bb698d5632e9547a72cd10b372c24922c63b4614e4899fad9b3f5a2"
  end

  def make_deps
    ENV.deparallelize
    ENV["CARGO_HOME"]="./.cargo"
    # Here is the workaround to use opam 2.0.9 because Tezos is currently not compatible with opam 2.1.0 and newer
    arch = RUBY_PLATFORM.include?("arm64") ? "arm64" : "x86_64"
    system "curl", "-L", "https://github.com/ocaml/opam/releases/download/2.0.9/opam-2.0.9-#{arch}-macos", "--create-dirs", "-o", "#{ENV["HOME"]}/.opam-bin/opam"
    system "chmod", "+x", "#{ENV["HOME"]}/.opam-bin/opam"
    ENV["PATH"]="#{ENV["HOME"]}/.opam-bin:#{ENV["PATH"]}"
    system "rustup-init", "--default-toolchain", "1.52.1", "-y"
    system "opam", "init", "--bare", "--debug", "--auto-setup", "--disable-sandboxing"
    system ["source .cargo/env",  "make build-deps"].join(" && ")
  end

  def install_template(dune_path, exec_path, name)
    bin.mkpath
    self.class.all_bins << name
    system ["eval $(opam env)", "dune build #{dune_path}", "cp #{exec_path} #{name}"].join(" && ")
    bin.install name
  end

  def install
    startup_contents =
      <<~EOS
      #!/usr/bin/env bash

      set -euo pipefail

      baker="#{bin}/tezos-baker-012-Psithaca"

      baker_dir="$DATA_DIR"

      baker_config="$baker_dir/config"
      mkdir -p "$baker_dir"

      if [ ! -f "$baker_config" ]; then
          "$baker" --base-dir "$baker_dir" \
                  --endpoint "$NODE_RPC_ENDPOINT" \
                  config init --output "$baker_config" >/dev/null 2>&1
      else
          "$baker" --base-dir "$baker_dir" \
                  --endpoint "$NODE_RPC_ENDPOINT" \
                  config update >/dev/null 2>&1
      fi

      launch_baker() {
          exec "$baker" \
              --base-dir "$baker_dir" --endpoint "$NODE_RPC_ENDPOINT" \
              run with local node "$NODE_DATA_DIR" "$@"
      }

      if [[ -z "$BAKER_ACCOUNT" ]]; then
          launch_baker
      else
          launch_baker "$BAKER_ACCOUNT"
      fi
    EOS
    File.write("tezos-baker-012-Psithaca-start", startup_contents)
    bin.install "tezos-baker-012-Psithaca-start"
    make_deps
    install_template "src/proto_012_Psithaca/bin_baker/main_baker_012_Psithaca.exe",
                     "_build/default/src/proto_012_Psithaca/bin_baker/main_baker_012_Psithaca.exe",
                     "tezos-baker-012-Psithaca"
  end
  plist_options manual: "tezos-baker-012-Psithaca run with local node"
  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
      "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>Program</key>
          <string>#{opt_bin}/tezos-baker-012-Psithaca-start</string>
          <key>EnvironmentVariables</key>
            <dict>
              <key>DATA_DIR</key>
              <string>#{var}/lib/tezos/client</string>
              <key>NODE_DATA_DIR</key>
              <string></string>
              <key>NODE_RPC_ENDPOINT</key>
              <string>http://localhost:8732</string>
              <key>BAKER_ACCOUNT</key>
              <string></string>
          </dict>
          <key>RunAtLoad</key><true/>
          <key>StandardOutPath</key>
          <string>#{var}/log/#{name}.log</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/#{name}.log</string>
        </dict>
      </plist>
    EOS
  end
  def post_install
    mkdir "#{var}/lib/tezos/client"
  end
end
