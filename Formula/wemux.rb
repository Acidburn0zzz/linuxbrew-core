class Wemux < Formula
  desc "Enhances tmux's to provide multiuser terminal multiplexing"
  homepage "https://github.com/zolrath/wemux"
  url "https://github.com/zolrath/wemux/archive/v3.2.0.tar.gz"
  sha256 "8de6607df116b86e2efddfe3740fc5eef002674e551668e5dde23e21b469b06c"
  license "MIT"
  head "https://github.com/zolrath/wemux.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "57909369808e5a5b85c118d3cbab8a5ad2ef9c5139102ee3bf934a53e0467b09"
    sha256 cellar: :any_skip_relocation, big_sur:       "977fdbcc9dcbb4a9d6149d043cd1ac3e5887421e76eee644d1e3703be1e111cb"
    sha256 cellar: :any_skip_relocation, catalina:      "5fb4eaf177d1766716003032bfc632d02ebed302c57e00dc752ed3de4b9cf1f6"
    sha256 cellar: :any_skip_relocation, mojave:        "5fb4eaf177d1766716003032bfc632d02ebed302c57e00dc752ed3de4b9cf1f6"
    sha256 cellar: :any_skip_relocation, high_sierra:   "5fb4eaf177d1766716003032bfc632d02ebed302c57e00dc752ed3de4b9cf1f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "547d23982ba1711c8d8a5d5a11595e5801ff52eb1a1a31d50096910a4b029db1" # linuxbrew-core
  end

  depends_on "tmux"

  def install
    inreplace "wemux", "/usr/local/etc", etc
    bin.install "wemux"
    man1.install "man/wemux.1"

    inreplace "wemux.conf.example", "change_this", ENV["USER"]
    etc.install "wemux.conf.example" => "wemux.conf"
  end

  def caveats
    <<~EOS
      Your current user account has been automatically added as a wemux host.

      To give a user the ability to host wemux sessions add them to the
      host_list array in:
        #{etc}/wemux.conf

      Either edit the file in your text editor of choice or run `wemux conf` to
      open the file in your $EDITOR.
    EOS
  end

  test do
    system "#{bin}/wemux", "help"
  end
end
