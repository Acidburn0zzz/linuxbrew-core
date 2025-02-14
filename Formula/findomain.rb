class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/findomain"
  url "https://github.com/Edu4rdSHL/findomain/archive/5.0.0.tar.gz"
  sha256 "4e16e35bca6d6d5f875bb6fbcada3606894ecee01591d7849312bd8b91b4464c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0f213e410ded04635d94dfe4d1d26f94575b6314393f703eb773633f91187895"
    sha256 cellar: :any_skip_relocation, big_sur:       "7b0892fedc69b7d8c4cf72bfe69fb1e97acf389f632b9284a36785a870d0eae3"
    sha256 cellar: :any_skip_relocation, catalina:      "2acb52fee0340692c6590e251332fa340fd4e6e1e0a23d8a2263c4b332a64bc7"
    sha256 cellar: :any_skip_relocation, mojave:        "6119ffa60ad0baa0e12335a2aaf7e2017b95da4cde68f9f6a739534e00fc65f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3923fa63bd68534a556030bfc2a421c822dd906b4df62138200adcc0e0389d7" # linuxbrew-core
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
