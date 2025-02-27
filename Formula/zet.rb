class Zet < Formula
  desc "CLI utility to find the union, intersection, and set difference of files"
  homepage "https://github.com/yarrow/zet"
  url "https://github.com/yarrow/zet/archive/refs/tags/0.2.0.tar.gz"
  sha256 "b001632ecff545411908a9b365dbac6f930e563233547a4cb0ad210d3066952b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c6e7d941904683befbbb15613f071a946a144add3cac297592c104d6928dc364"
    sha256 cellar: :any_skip_relocation, big_sur:       "4515a47a131a1cf5f99a142985563c852115ab85eb9930d763331295bc001c0c"
    sha256 cellar: :any_skip_relocation, catalina:      "27a2d603392d8f3eb4334524a9806b8138c1ce6016be87c4c17536861e1b1343"
    sha256 cellar: :any_skip_relocation, mojave:        "4aa63c78cb8fe11496f62fbbc3a8877640273c8171c28fa44be0fd0325b06a76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23e781f7009f4eb495eecfc67dd7f61c1e059aaae494d62fbd9bae5a61abb783" # linuxbrew-core
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"foo.txt").write("1\n2\n3\n4\n5\n")
    (testpath/"bar.txt").write("1\n2\n4\n")
    assert_equal "3\n5\n", shell_output("#{bin}/zet diff foo.txt bar.txt")
  end
end
