class Skymaker < Formula
  desc "Generates fake astronomical images"
  homepage "https://www.astromatic.net/software/skymaker"
  # Upstream URL is currently 404 Not Found. Can re-enable if upstream restores URL.
  # url "https://www.astromatic.net/download/skymaker/skymaker-3.10.5.tar.gz"
  url "https://web.archive.org/web/20161206053718/www.astromatic.net/download/skymaker/skymaker-3.10.5.tar.gz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/skymaker/skymaker-3.10.5.tar.gz"
  sha256 "a16f9c2bd653763b5e1629e538d49f63882c46291b479b4a4997de84d8e9fb0f"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "44e3eadc4f4a2984ffff332f93e9aa7a383b7a395ccd9fd6714a237a48ed72d0"
    sha256 cellar: :any, big_sur:       "2262e9a1f11f41c75fc8ccb47717f779bbb62bf86ddbabd42975fe684278efb9"
    sha256 cellar: :any, catalina:      "af78e7af9c84517e8f7db071ef3718a34eafc39d6eac3357d77ee183d4fe2cdf"
    sha256 cellar: :any, mojave:        "ef2182885eb6952289057ce2756ac56ec9a88397e746b694529a937eaa28b943"
    sha256 cellar: :any, high_sierra:   "6e7aa4c817624d5631293d0421b25eec132e41bfe3d75f9044a85dd02f73de4a"
    sha256 cellar: :any, x86_64_linux:  "4a641bb5bd1b089282393e43d6458ef8a2955c0833ddb6262bb14a4b17431b6a" # linuxbrew-core
  end

  depends_on "autoconf" => :build
  depends_on "fftw"

  def install
    system "autoconf"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "added", shell_output("#{bin}/sky 2>&1")
  end
end
