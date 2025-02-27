class Gearman < Formula
  desc "Application framework to farm out work to other machines or processes"
  homepage "http://gearman.org/"
  url "https://github.com/gearman/gearmand/releases/download/1.1.19.1/gearmand-1.1.19.1.tar.gz"
  sha256 "8ea6e0d16a0c924e6a65caea8a7cd49d3840b9256d440d991de4266447166bfb"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "6e3d3504ff3a5d4fb152ec03975aacea300cfca0875c8370c6dcb7bbcbc9ccda"
    sha256 cellar: :any,                 big_sur:       "1a700a2938db5507f0f2b81c58988d563c5ad41eeb892bc31f1f4c918a882930"
    sha256 cellar: :any,                 catalina:      "3a1a4bc57288dea7905134d9290c88a04273f7cc6361646694324e3bc9eb42d3"
    sha256 cellar: :any,                 mojave:        "582d1de464569352536501e2aa832a9bc540220eae335b682411ecadffbfe198"
    sha256 cellar: :any,                 high_sierra:   "8664f5b9c91ef99190cb70000758aa3d50f68afcad01d2e8cac234adf6a5424c"
  end

  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "boost"
  depends_on "libevent"
  depends_on "libmemcached"

  uses_from_macos "gperf" => :build
  uses_from_macos "sqlite"

  on_linux do
    depends_on "util-linux" # for libuuid
  end

  def install
    # Work around "error: no member named 'signbit' in the global namespace"
    # encountered when trying to detect boost regex in configure
    if MacOS.version == :high_sierra
      ENV.delete("HOMEBREW_SDKROOT")
      ENV.delete("SDKROOT")
    end

    # https://bugs.launchpad.net/gearmand/+bug/1368926
    Dir["tests/**/*.cc", "libtest/main.cc"].each do |test_file|
      next unless /std::unique_ptr/.match?(File.read(test_file))

      inreplace test_file, "std::unique_ptr", "std::auto_ptr"
    end

    args = %W[
      --prefix=#{prefix}
      --localstatedir=#{var}
      --disable-silent-rules
      --disable-dependency-tracking
      --disable-cyassl
      --disable-hiredis
      --disable-libdrizzle
      --disable-libpq
      --disable-libtokyocabinet
      --disable-ssl
      --enable-libmemcached
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-memcached=#{Formula["memcached"].opt_bin}/memcached
      --with-sqlite3
      --without-mysql
      --without-postgresql
    ]

    ENV.append_to_cflags "-DHAVE_HTONLL"

    (var/"log").mkpath
    system "./configure", *args
    system "make", "install"
  end

  service do
    run opt_sbin/"gearmand"
  end

  test do
    assert_match(/gearman\s*Error in usage/, shell_output("#{bin}/gearman --version 2>&1", 1))
  end
end
