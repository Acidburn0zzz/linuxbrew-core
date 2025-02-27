class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://github.com/epi052/feroxbuster/archive/v2.4.0.tar.gz"
  sha256 "077dec4b9e043b6a05582ea5598c35f4ea70beb45c8e516fee8279257ddf6c67"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a0ca20eec229c0cd78acc1ad2819c48979bc782ccafea8ed1f7183e2a63066c3"
    sha256 cellar: :any_skip_relocation, big_sur:       "31a6716c3fdfd369dee154888bff3c16543b038ea37a656fdce9caebe308917b"
    sha256 cellar: :any_skip_relocation, catalina:      "e93ee95bbf9edd561c8783dd43ffecf393c4e28593ad228417fea9c1aa98412e"
    sha256 cellar: :any_skip_relocation, mojave:        "2ce9bf75bcff1c1bf9d46e369d489698c05fc1e46de26c3cf00e8c78f10b0c84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5401f24f718f1d864c67429b6694a10af6e39baf4e4ac0768b5e1e9d932fe14b"
  end

  depends_on "rust" => :build
  depends_on "miniserve" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"wordlist").write <<~EOS
      a.txt
      b.txt
    EOS

    (testpath/"web").mkpath
    (testpath/"web/a.txt").write "a"
    (testpath/"web/b.txt").write "b"

    port = free_port
    pid = fork do
      exec "miniserve", testpath/"web", "-i", "127.0.0.1", "--port", port.to_s
    end

    sleep 1

    begin
      exec bin/"feroxbuster", "-q", "-w", testpath/"wordlist", "-u", "http://127.0.0.1:#{port}"
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
