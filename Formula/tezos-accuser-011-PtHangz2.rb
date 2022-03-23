# SPDX-FileCopyrightText: 2021 Oxhead Alpha
# SPDX-License-Identifier: LicenseRef-MIT-OA

class TezosAccuser011Pthangz2 < Formula
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
    root_url "https://github.com/serokell/tezos-packaging/releases/download/#{TezosAccuser011Pthangz2.version}/"
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
    sha256 cellar: :any, big_sur: "b7648005a94bbfc04cc1750f4fb6e7387c433d5b20a9f9cb311cc1fb51e3abc8"
    sha256 cellar: :any, catalina: "c5ef686b2f4fa7f0f2d985f539d665e4318cec41ca3f8f4c6ef113874c487563"
    sha256 cellar: :any, arm64_big_sur: "bc15bdf710fbfebe901907c9976fd4b1f0c3760bf698a5afb2b2c555a5f9167c"
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

      accuser="#{bin}/tezos-accuser-011-PtHangz2"

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
    File.write("tezos-accuser-011-PtHangz2-start", startup_contents)
    bin.install "tezos-accuser-011-PtHangz2-start"
    make_deps
    install_template "src/proto_011_PtHangz2/bin_accuser/main_accuser_011_PtHangz2.exe",
                     "_build/default/src/proto_011_PtHangz2/bin_accuser/main_accuser_011_PtHangz2.exe",
                     "tezos-accuser-011-PtHangz2"
  end

  plist_options manual: "tezos-accuser-011-PtHangz2 run"
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
          <string>#{opt_bin}/tezos-accuser-011-PtHangz2-start</string>
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
