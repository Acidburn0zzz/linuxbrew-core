class ForkCleaner < Formula
  desc "Cleans up old and inactive forks on your GitHub account"
  homepage "https://github.com/caarlos0/fork-cleaner"
  url "https://github.com/caarlos0/fork-cleaner/archive/v2.2.1.tar.gz"
  sha256 "24397ec0ad89738aee48b77e80033a2e763941e67e67b673b6ff86ab04367283"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "83f76a38e1962eeb871e00a3171791e70af5f3f0ab5d134fa6437b875f577bc6"
    sha256 cellar: :any_skip_relocation, big_sur:       "4d89ad868b65bb6375a39376ff4470e435df3250d5b6295d7c27040814bf9876"
    sha256 cellar: :any_skip_relocation, catalina:      "5f369eaafb9f81888458504d90b0cb5a3f6f822c3617168031c183310350a579"
    sha256 cellar: :any_skip_relocation, mojave:        "48a456d3a6483c5b4b5200c5e08d2e3093ae7dc4adf265d56042a80f35f19da3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff3afd72275193282e51cfd64896de6a27675fcd1cabc8a90351ef78c706d802" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "fork-cleaner"
    prefix.install_metafiles
  end

  test do
    output = shell_output("#{bin}/fork-cleaner 2>&1", 1)
    assert_match "missing github token", output
  end
end
