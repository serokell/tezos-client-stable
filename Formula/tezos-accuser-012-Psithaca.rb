# SPDX-FileCopyrightText: 2022 Oxhead Alpha
# SPDX-License-Identifier: LicenseRef-MIT-OA

class TezosAccuser012Psithaca < Formula
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

  dependencies = %w[gmp hidapi libev libffi]
  dependencies.each do |dependency|
    depends_on dependency
  end
  desc "Daemon for accusing"

  bottle do
    root_url "https://github.com/serokell/tezos-packaging/releases/download/#{TezosAccuser012Psithaca.version}/"
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: ""
    sha256 cellar: :any, catalina: ""
    sha256 cellar: :any, big_sur: "f2b8e2c04bc6e906bfa8a5757f7fcf0d4713e74f76736b34c86f1eb572eb3043"
    sha256 cellar: :any, catalina: "7dd91b0a533906be9f52683e28067296b7063fbd5551d6fc2c525d6ffe253e96"
    sha256 cellar: :any, arm64_big_sur: "84d83f553e8f87c3037eb70a11f7e60517fbd06ff2a82c762cfb654b63617c69"
  end

  def make_deps
    ENV.deparallelize
    ENV["CARGO_HOME"]="./.cargo"
    # Here is the workaround to use opam 2.0 because Tezos is currently not compatible with opam 2.1.0 and newer
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

      accuser="#{bin}/tezos-accuser-012-Psithaca"

      accuser_dir="$DATA_DIR"

      accuser_config="$accuser_dir/config"
      mkdir -p "$accuser_dir"

      if [ ! -f "$accuser_config" ]; then
          "$accuser" --base-dir "$accuser_dir" \
                    --endpoint "$NODE_RPC_ENDPOINT" \
                    config init --output "$accuser_config" >/dev/null 2>&1
      else
          "$accuser" --base-dir "$accuser_dir" \
                    --endpoint "$NODE_RPC_ENDPOINT" \
                    config update >/dev/null 2>&1
      fi

      exec "$accuser" --base-dir "$accuser_dir" \
          --endpoint "$NODE_RPC_ENDPOINT" \
          run
    EOS
    File.write("tezos-accuser-012-Psithaca-start", startup_contents)
    bin.install "tezos-accuser-012-Psithaca-start"
    make_deps
    install_template "src/proto_012_Psithaca/bin_accuser/main_accuser_012_Psithaca.exe",
                     "_build/default/src/proto_012_Psithaca/bin_accuser/main_accuser_012_Psithaca.exe",
                     "tezos-accuser-012-Psithaca"
  end

  plist_options manual: "tezos-accuser-012-Psithaca run"
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
          <string>#{opt_bin}/tezos-accuser-012-Psithaca-start</string>
          <key>EnvironmentVariables</key>
            <dict>
              <key>DATA_DIR</key>
              <string>#{var}/lib/tezos/client</string>
              <key>NODE_RPC_ENDPOINT</key>
              <string>http://localhost:8732</string>
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
