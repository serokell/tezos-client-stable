# SPDX-FileCopyrightText: 2021 Oxhead Alpha
# SPDX-License-Identifier: LicenseRef-MIT-OA

class TezosEndorser011Pthangz2 < Formula
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

  desc "Daemon for endorsing"

  bottle do
    root_url "https://github.com/serokell/tezos-packaging/releases/download/#{TezosEndorser011Pthangz2.version}/"
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
    sha256 cellar: :any, big_sur: "f3be51324f5d8438b07606f78ba78ba9235307efa670c49fe0814afe18956214"
    sha256 cellar: :any, catalina: "b28fc4e07752c4b81d344591c428aa09728b98bbd406ecf6dee17d7bf7264789"
    sha256 cellar: :any, arm64_big_sur: "46d65bc78ba02d3d75904843cfbae52048877a6c9ae5b2f9fef898063f29bd00"
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

      endorser="#{bin}/tezos-endorser-011-PtHangz2"

      endorser_dir="$DATA_DIR"

      endorser_config="$endorser_dir/config"
      mkdir -p "$endorser_dir"

      if [ ! -f "$endorser_config" ]; then
          "$endorser" --base-dir "$endorser_dir" \
                      --endpoint "$NODE_RPC_ENDPOINT" \
                      config init --output "$endorser_config" >/dev/null 2>&1
      else
          "$endorser" --base-dir "$endorser_dir" \
                      --endpoint "$NODE_RPC_ENDPOINT" \
                      config update >/dev/null 2>&1
      fi

      launch_endorser() {
          exec "$endorser" --base-dir "$endorser_dir" \
              --endpoint "$NODE_RPC_ENDPOINT" \
              run "$@"
      }

      if [[ -z "$ENDORSER_ACCOUNT" ]]; then
          launch_endorser
      else
          launch_endorser "$ENDORSER_ACCOUNT"
      fi
    EOS
    File.write("tezos-endorser-011-PtHangz2-start", startup_contents)
    bin.install "tezos-endorser-011-PtHangz2-start"
    make_deps
    install_template "src/proto_011_PtHangz2/bin_endorser/main_endorser_011_PtHangz2.exe",
                     "_build/default/src/proto_011_PtHangz2/bin_endorser/main_endorser_011_PtHangz2.exe",
                     "tezos-endorser-011-PtHangz2"
  end

  plist_options manual: "tezos-endorser-011-PtHangz2 run"
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
          <string>#{opt_bin}/tezos-endorser-011-PtHangz2-start</string>
          <key>EnvironmentVariables</key>
            <dict>
              <key>DATA_DIR</key>
              <string>#{var}/lib/tezos/client</string>
              <key>NODE_RPC_ENDPOINT</key>
              <string>http://localhost:8732</string>
              <key>ENDORSER_ACCOUNT</key>
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
