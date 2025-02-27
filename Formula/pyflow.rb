class Pyflow < Formula
  desc "Installation and dependency system for Python"
  homepage "https://github.com/David-OConnor/pyflow"
  url "https://github.com/David-OConnor/pyflow/archive/0.3.1.tar.gz"
  sha256 "36be46aaebf7bc77d2f250b3646024fb1f2f04d92113d3ce46ea5846f7e4c4f4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "88f8e4c0528d6b4eea13d4bda9cabd3dafc7fb85b044bc0fe660530fb00f77e5"
    sha256 cellar: :any_skip_relocation, big_sur:       "619d1a1095428a7dc3ba1367c4ca5a64dd49eff8d5a91cbfd7e9966b9be2cc5a"
    sha256 cellar: :any_skip_relocation, catalina:      "2658cf76995468b62f16119d3b6288081a0ab95ca410bc445754ee67099567bd"
    sha256 cellar: :any_skip_relocation, mojave:        "f25d6af683f972dbdc918433965c7b589356fd4323766b1b778120ef5bdce6fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6babeceb2bdffeef9f8a8009c633d01030a3c0a28f49ea021b43e873a4b982c1" # linuxbrew-core
  end

  depends_on "rust" => :build
  depends_on "python@3.9" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"
    pipe_output("#{bin}/pyflow init", "#{Formula["python@3.9"].version}\n1")
    system bin/"pyflow", "install", "boto3"

    assert_predicate testpath/"pyproject.toml", :exist?
    assert_predicate testpath/"pyflow.lock", :exist?
    assert_match "boto3", (testpath/"pyproject.toml").read
  end
end
