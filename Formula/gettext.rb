class Gettext < Formula
  desc "GNU internationalization (i18n) and localization (l10n) library"
  homepage "https://www.gnu.org/software/gettext/"
  url "https://ftp.gnu.org/gnu/gettext/gettext-0.21.tar.gz"
  mirror "https://ftpmirror.gnu.org/gettext/gettext-0.21.tar.gz"
  mirror "http://ftp.gnu.org/gnu/gettext/gettext-0.21.tar.gz"
  sha256 "c77d0da3102aec9c07f43671e60611ebff89a996ef159497ce8e59d075786b12"
  license "GPL-3.0-or-later"
  revision 2 unless OS.mac?

  bottle do
    sha256 arm64_big_sur: "339b62b52ba86dfa73091d37341104b46c01ae354ca425000732df689305442b"
    sha256 big_sur:       "a025e143fe3f5f7e24a936b8b0a4926acfdd025b11d62024e3d355c106536d56"
    sha256 catalina:      "cdea54f52b7c36ebcb5fe26a1cf736d7cd6fd5f2fd016dd8357a8624ffd6b5f8"
    sha256 mojave:        "99707d4dcc731faf980333365a694e9500f2f012f84c0bcb6d8cb5d620c2ce08"
    sha256 high_sierra:   "5ac5783e31205b92907b46bfaaa142620aea7ee3fc4d996876b0913fd2315695"
    sha256 x86_64_linux:  "92b2afc5a81a3e51d8da1bdd528af989b60d05a7cf0944479199db89d37adfd7" # linuxbrew-core
  end

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  def install
    args = [
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--disable-debug",
      "--prefix=#{prefix}",
      "--with-included-glib",
      "--with-included-libcroco",
      "--with-included-libunistring",
      "--with-included-libxml",
      "--with-emacs",
      "--with-lispdir=#{elisp}",
      "--disable-java",
      "--disable-csharp",
      # Don't use VCS systems to create these archives
      "--without-git",
      "--without-cvs",
      "--without-xz",
    ]
    args << if OS.mac?
      # Ship libintl.h. Disabled on linux as libintl.h is provided by glibc
      # https://gcc-help.gcc.gnu.narkive.com/CYebbZqg/cc1-undefined-reference-to-libintl-textdomain
      # There should never be a need to install gettext's libintl.h on
      # GNU/Linux systems using glibc. If you have it installed you've borked
      # your system somehow.
      "--with-included-gettext"
    else
      "--with-libxml2-prefix=#{Formula["libxml2"].opt_prefix}"
    end
    system "./configure", *args
    system "make"
    ENV.deparallelize # install doesn't support multiple make jobs
    system "make", "install"
  end

  test do
    system bin/"gettext", "test"
  end
end
