class Nodebrew < Formula
  desc "Node.js version manager"
  homepage "https://github.com/hokaccha/nodebrew"
  url "https://github.com/hokaccha/nodebrew/archive/v1.1.0.tar.gz"
  sha256 "b2046d97392ed971254bee2026cfcf8fb59225f51b566ec4b77e9355a861c8a7"
  license "MIT"
  head "https://github.com/hokaccha/nodebrew.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "dad75f41cddb514ed89c01ae75b38c18ab21e4cb0ee2b9135c986968975b058d" # linuxbrew-core
  end

  def install
    bin.install "nodebrew"
    bash_completion.install "completions/bash/nodebrew-completion" => "nodebrew"
    zsh_completion.install "completions/zsh/_nodebrew"
  end

  def caveats
    <<~EOS
      You need to manually run setup_dirs to create directories required by nodebrew:
        #{opt_bin}/nodebrew setup_dirs

      Add path:
        export PATH=$HOME/.nodebrew/current/bin:$PATH

      To use Homebrew's directories rather than ~/.nodebrew add to your profile:
        export NODEBREW_ROOT=#{var}/nodebrew
    EOS
  end

  test do
    assert_match "v0.10.0", shell_output("#{bin}/nodebrew ls-remote")
  end
end
