class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.11.2.tar.gz"
  sha256 "c1f7454a93e334484cc15ec8a88ded4080bf5e39df2b0dff729a2e77044dc3df"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "d792e6ff2dbbc51e436000addd1bcf86edb34feb4b53194e64f6889d48527ee0"
    sha256                               big_sur:       "a62461a2f591e9a765801d02ea83e0977782839e68a1886920a0928423683501"
    sha256                               catalina:      "560c574cd0a9ae0958ae32ad136476982552186d6d500ac1167d43eff72d2007"
    sha256 cellar: :any,                 mojave:        "f24d3cde3c06c8fd3806979d2c34c9edd8ad67e014c8f3aee69a487ccb1058c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daf76f0d786ff1c0c75a78b1abbef803622b4becb48ee626050013fc67558604" # linuxbrew-core
  end

  depends_on "pkg-config" => :build
  depends_on "ruby" if Hardware::CPU.arm?

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "ruby", since: :catalina

  def install
    if MacOS.version >= :mojave && MacOS::CLT.installed?
      ENV["SDKROOT"] = ENV["HOMEBREW_SDKROOT"] = MacOS::CLT.sdk_path(MacOS.version)
    end

    ENV["GEM_HOME"] = libexec
    system "gem", "build", "cocoapods.gemspec"
    system "gem", "install", "cocoapods-#{version}.gem"
    # Other executables don't work currently.
    bin.install libexec/"bin/pod", libexec/"bin/xcodeproj"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    system "#{bin}/pod", "list"
  end
end
