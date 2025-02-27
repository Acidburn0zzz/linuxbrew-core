class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.17.0.tar.gz"
  sha256 "9530e616d42b4158ffcc5dd1befdc87ab2ea2af784fce6c57aec8c42a71a4ce2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5c3c84d492dbf86c9041469cabfb8c698660ded0a2da658678d9583ea21667b7"
    sha256 cellar: :any_skip_relocation, big_sur:       "1fbe03b66b76929c8cb919508f59e7fd9cfae2cd10ec177a775d60c8ef5f8b94"
    sha256 cellar: :any_skip_relocation, catalina:      "c33692e53fbf7eca2cac472d3ca6e7a2555edbc14048a95e123160840853f314"
    sha256 cellar: :any_skip_relocation, mojave:        "f1de3efb23c8eee281157668801ef6e1974d410a90c7708b16d3667d96f5632f"
  end

  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "compiler-cli")
  end

  test do
    Dir.chdir testpath
    system bin/"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system "rebar3", "eunit"
  end
end
