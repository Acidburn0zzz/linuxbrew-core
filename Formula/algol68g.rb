class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  # The upstream download url currently returns a 404 error.
  # Until fixed, we can use a copy from OpenBSD.
  url "https://ftp.openbsd.org/pub/OpenBSD/distfiles/algol68g-2.8.5.tar.gz"
  mirror "https://jmvdveer.home.xs4all.nl/algol68g-2.8.5.tar.gz"
  sha256 "0f757c64a8342fe38ec501bde68b61d26d051dffd45742ca58b7288a99c7e2d8"
  license "GPL-3.0-or-later"

  # The homepage hasn't been updated for the latest release (2.8.5), even though
  # the related archive is available on the site. Until the website is updated
  # (and seems like it will continue to be updated for new releases), we're
  # checking a third-party source for new releases as an interim solution.
  livecheck do
    url "https://openports.se/lang/algol68g"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "5e90719ca013bddd6066b0e1e87d6162094ee73ef300233f1f75d9833bf4dc42"
    sha256 big_sur:       "7b7bb03b6cbe89d253b5e88294ecc4edf61a0687c4534f26ffb7422efe22e52d"
    sha256 catalina:      "046ba5e9ec0d0856557085fdf1acde227cd829d9955da28046e98c9a5ee84c09"
    sha256 mojave:        "7e1acd53615ebc407aaae64eb23af6047dbbd42f967e422b3fcfa0c6d01307b6"
    sha256 high_sierra:   "18013401e3eed914022e0a34c6b9b1ed415ec679113de78970d74aa52b0a35e8"
    sha256 x86_64_linux:  "54dfb7001fa1aba552b02d6c63bd20328b446170f06c432e1ddc1ab26e4cd5a1" # linuxbrew-core
  end

  on_linux do
    depends_on "postgresql"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"hello.alg"
    path.write <<~EOS
      print("Hello World")
    EOS

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end
