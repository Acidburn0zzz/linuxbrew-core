class Taskell < Formula
  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.11.4.tar.gz"
  sha256 "0d4f3f54fb0b975f969d7ef8a810bbc7a78e0b46aec28cc4cb337ee36e8abdfc"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0af5900a42ff1461448170364e3f8d7f81f274bb5e44db84779a34f6e76a7e46"
    sha256 cellar: :any_skip_relocation, big_sur:       "5b343d4e8b61335b598fda4c5d07084f7f31186c28212ce70eeee3216f7ceeeb"
    sha256 cellar: :any_skip_relocation, catalina:      "aa033e92954aee8915a4ede120e11015ce2aaadb9f313bd893656d78f20805ea"
    sha256 cellar: :any_skip_relocation, mojave:        "df124ebb5b47ddd293c637ea656c27484c484d43984be3f3c940f50b6330b161"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58e678e3afea24e9be5467ca9e45c5b11a7140b4349c77b23f3b142858c0afbf" # linuxbrew-core
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "hpack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "hpack"
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"test.md").write <<~EOS
      ## To Do

      - A thing
      - Another thing
    EOS

    expected = <<~EOS
      test.md
      Lists: 1
      Tasks: 2
    EOS

    assert_match expected, shell_output("#{bin}/taskell -i test.md")
  end
end
