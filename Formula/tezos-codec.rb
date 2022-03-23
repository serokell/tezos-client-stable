# SPDX-FileCopyrightText: 2021 Oxhead Alpha
# SPDX-License-Identifier: LicenseRef-MIT-OA

class TezosCodec < Formula
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
  desc "A client to decode and encode JSON"

  bottle do
    root_url "https://github.com/serokell/tezos-packaging/releases/download/#{TezosCodec.version}/"
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
    sha256 cellar: :any, big_sur: "f994339572337c4f23dcd24ac263c2453491f311a1ae604b73ade3b15a7ae4b0"
    sha256 cellar: :any, catalina: "250e6a5ebc8efb44d9b9c7048f00519b09c96f3b62863bb5c2e897de7250b0d6"
    sha256 cellar: :any, arm64_big_sur: "8498b3ba192453f9bbf974fcf5915dd71eb96f95f62b18d454f40b192bdd7759"
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
    make_deps
    install_template "src/bin_codec/codec.exe",
                     "_build/default/src/bin_codec/codec.exe",
                     "tezos-codec"
  end
end
