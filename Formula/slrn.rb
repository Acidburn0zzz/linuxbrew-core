class Slrn < Formula
  desc "Powerful console-based newsreader"
  homepage "https://slrn.info/"
  url "https://jedsoft.org/releases/slrn/slrn-1.0.3a.tar.bz2"
  sha256 "3ba8a4d549201640f2b82d53fb1bec1250f908052a7983f0061c983c634c2dac"
  license "GPL-2.0-or-later"
  revision 1
  head "git://git.jedsoft.org/git/slrn.git", branch: "master"

  livecheck do
    url "https://jedsoft.org/releases/slrn/"
    regex(/href=.*?slrn[._-]v?(\d+(?:\.\d+)+(?:[a-z]?\d*)?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "b714ac9c245119ba08001c7729f77093491457c54f17b2d1d09184f690ffa288"
    sha256 big_sur:       "1e3a47c2adbd775237d1b34cba86c82a14096d792a922887f76f6eadb0964513"
    sha256 catalina:      "5440f5353ec5ae3f3a2cdd3ed43b931bd41db738ee4b993b0ec3b41618f7406f"
    sha256 mojave:        "35550c096c81454ae0756d0831fa8a6dd2db9857db591b72f8cf96aeb4e4fac3"
    sha256 x86_64_linux:  "2948bfb6d066d51e4e6adef0c42ce9be91b03ead397343ccb3f1e6b4eab9bc9d" # linuxbrew-core
  end

  depends_on "openssl@1.1"
  depends_on "s-lang"

  def install
    bin.mkpath
    man1.mkpath
    mkdir_p "#{var}/spool/news/slrnpull"

    # Work around configure issues with Xcode 12.  Hopefully this will not be
    # needed after next slrn release.
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--with-slrnpull=#{var}/spool/news/slrnpull",
                          "--with-slang=#{HOMEBREW_PREFIX}"
    system "make", "all", "slrnpull"

    ENV.deparallelize
    system "make", "install"
  end

  test do
    ENV["TERM"] = "xterm"
    assert_match version.to_s, shell_output("#{bin}/slrn --show-config")
  end
end
