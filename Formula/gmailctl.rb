class Gmailctl < Formula
  desc "Declarative configuration for Gmail filters"
  homepage "https://github.com/mbrt/gmailctl"
  url "https://github.com/mbrt/gmailctl/archive/v0.9.0.tar.gz"
  sha256 "1b4d04c0fa46990231565cb743d3b9aba2011501322c224a96bec747003c35e1"
  license "MIT"
  head "https://github.com/mbrt/gmailctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "32361886ab245d106bfdabc60eceb43f803636aa5c4db59187396f2dcf80674e"
    sha256 cellar: :any_skip_relocation, big_sur:       "3c9080dfdc290ee0747fbd7d70c786166636d22c0114bdfd8dfe27f8ad0ca330"
    sha256 cellar: :any_skip_relocation, catalina:      "6239ab2e534e2b0b013bdf0068a75d88aa51abb91fc9f9b8f079dc3c80abdd41"
    sha256 cellar: :any_skip_relocation, mojave:        "b6a4a9554edec82d0386efa66a88bf4d7503d3cda5d6e96940834afd270c90e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f81e41e24be6f157e0694e365005f27b029e49449ad164a0a847bb81704edc6" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "cmd/gmailctl/main.go"
    pkgshare.install ["default-config.jsonnet", "gmailctl.libsonnet"]
  end

  test do
    cp pkgshare/"default-config.jsonnet", testpath
    cp pkgshare/"gmailctl.libsonnet", testpath

    assert_includes shell_output("#{bin}/gmailctl init --config #{testpath} 2>&1"),
      "The credentials are not initialized"
  end
end
