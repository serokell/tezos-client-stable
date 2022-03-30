# SPDX-FileCopyrightText: 2021 Oxhead Alpha
# SPDX-License-Identifier: LicenseRef-MIT-OA

class TezosSandbox < Formula
  @all_bins = []

  class << self
    attr_accessor :all_bins
  end
  homepage "https://gitlab.com/tezos/tezos"

  url "https://gitlab.com/tezos/tezos.git", :tag => "v12.1", :shallow => false

  version "v12.1-1"

  build_dependencies = %w[pkg-config autoconf rsync wget rustup-init]
  build_dependencies.each do |dependency|
    depends_on dependency => :build
  end

  dependencies = %w[gmp hidapi libev libffi coreutils util-linux]
  dependencies.each do |dependency|
    depends_on dependency
  end
  desc "A tool for setting up and running testing scenarios with the local blockchain"

  bottle do
    root_url "https://github.com/serokell/tezos-packaging/releases/download/#{TezosSandbox.version}/"
    sha256 cellar: :any, big_sur: "df38585470be64eef35d13d00069991130cee38dfcae300ee0e262d3b6490370"
    sha256 cellar: :any, arm64_big_sur: "a4b6f1246f4b6bd76b0c03d1004bd77f48aa6ab8848b7f9ce671e9783b9e2bf6"
    sha256 cellar: :any, catalina: "42261e4fbbca5b44e0f0058ec84bb8bf4f6e841bdd548c0d1ca180e47ca06787"
  end

  def make_deps
    ENV.deparallelize
    ENV["CARGO_HOME"]="./.cargo"
    # Disable usage of instructions from the ADX extension to avoid incompatibility
    # with old CPUs, see https://gitlab.com/dannywillems/ocaml-bls12-381/-/merge_requests/135/
    ENV["BLST_PORTABLE"]="yes"
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
    install_template "src/bin_sandbox/main.exe",
                     "_build/default/src/bin_sandbox/main.exe",
                     "tezos-sandbox"
  end

  # homebrew does not allow for post-setup modification of user files,
  # so we have to provide a caveat to be displayed for the user to adjust $PATH manually
  def caveats
    <<~EOS
      tezos-sandbox depends on 'coreutils' and 'util-linux', which have been installed. Please run the following command to bring them in scope:
        export PATH=#{HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin:#{HOMEBREW_PREFIX}/opt/util-linux/bin:$PATH
    EOS
  end
end
