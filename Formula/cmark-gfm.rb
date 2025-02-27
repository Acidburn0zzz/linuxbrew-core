class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark-gfm"
  url "https://github.com/github/cmark-gfm/archive/0.29.0.gfm.2.tar.gz"
  version "0.29.0.gfm.2"
  sha256 "66d92c8bef533744674c5b64d8744227584b12704bcfebbe16dab69f81e62029"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "736d33570252cdc6a4c6637880d22dede82d2e33a5efa61d756acd4120461ccf"
    sha256 cellar: :any,                 big_sur:       "d8976bd1e57ec2077225849ae9fa86e46fd1d2c81c494ccd59267f741876a8d1"
    sha256 cellar: :any,                 catalina:      "803c1dee92501ddddcd5b67ee189d52826a644221afadd85da71a1d1752e8631"
    sha256 cellar: :any,                 mojave:        "d1f927bcec1eea8eeedec679cf04a0f9e297d65e77f096668f9e4e6d86d49403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3619b11b73ad49758e55f495eee771d81c86002d881b12486b15ae374f9949a7" # linuxbrew-core
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

  conflicts_with "cmark", because: "both install a `cmark.h` header"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "install"
    end
  end

  test do
    output = pipe_output("#{bin}/cmark-gfm --extension autolink", "https://brew.sh")
    assert_equal '<p><a href="https://brew.sh">https://brew.sh</a></p>', output.chomp
  end
end
