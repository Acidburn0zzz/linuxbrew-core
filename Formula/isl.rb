class Isl < Formula
  desc "Integer Set Library for the polyhedral model"
  homepage "https://libisl.sourceforge.io/"
  # NOTE: Always use tarball instead of git tag for stable version.
  #
  # Currently isl detects its version using source code directory name
  # and update isl_version() function accordingly.  All other names will
  # result in isl_version() function returning "UNKNOWN" and hence break
  # package detection.
  url "https://libisl.sourceforge.io/isl-0.24.tar.xz"
  sha256 "043105cc544f416b48736fff8caf077fb0663a717d06b1113f16e391ac99ebad"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?isl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "cf7f8b77fc0e51bc9c9921306737176e6f9e03062255a525d9ab59cf91ed3d36"
    sha256 cellar: :any,                 big_sur:       "d8c7026042e122143e0729bf3a596be77753b8cfeddcae200cd3a3c18176800c"
    sha256 cellar: :any,                 catalina:      "f33ee49a23fbde05392be23110d14add72aaed390ffd3aefc400645eeb1772d4"
    sha256 cellar: :any,                 mojave:        "34b71567d6bfb7e4cb4aced1d089fe6d72988af02775730be26b5bcea483d065"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b58d25de0b7ed797118f32febe116ee2d7458767e6339d6a4ce51ff4ab11191" # linuxbrew-core
  end

  head do
    url "https://repo.or.cz/isl.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gmp"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-gmp=system",
                          "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}"
    system "make"
    system "make", "install"
    (share/"gdb/auto-load").install Dir["#{lib}/*-gdb.py"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <isl/ctx.h>

      int main()
      {
        isl_ctx* ctx = isl_ctx_alloc();
        isl_ctx_free(ctx);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lisl", "-o", "test"
    system "./test"
  end
end
