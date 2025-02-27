class ProofGeneral < Formula
  desc "Emacs-based generic interface for theorem provers"
  homepage "https://proofgeneral.github.io"
  url "https://github.com/ProofGeneral/PG/archive/v4.4.tar.gz"
  sha256 "1ba236d81768a87afa0287f49d4b2223097bc61d180468cbd997d46ab6132e7e"
  license "GPL-2.0"
  revision 2
  head "https://github.com/ProofGeneral/PG.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "89bdd53f3c8afd028343bbb03ce2311cdeeab93924b96817b1b408117adc60fd"
    sha256 cellar: :any_skip_relocation, big_sur:       "4fbcb27cb3b5bbdc7fba3cf07ca70953ab66cdd7749c85b06097d272cc31a630"
    sha256 cellar: :any_skip_relocation, catalina:      "ccc115760830d046c9e53277a571f451eb251c9b10c09589c627f146f4a9a4dd"
    sha256 cellar: :any_skip_relocation, mojave:        "ccc115760830d046c9e53277a571f451eb251c9b10c09589c627f146f4a9a4dd"
    sha256 cellar: :any_skip_relocation, high_sierra:   "ccc115760830d046c9e53277a571f451eb251c9b10c09589c627f146f4a9a4dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1d1bbe24c68b5ea6a16a423f647c52ec5cab971e7c74cc3c16836326a340071" # linuxbrew-core
  end

  depends_on "texi2html" => :build
  depends_on "texinfo" => :build
  depends_on "emacs"

  def install
    ENV.deparallelize # Otherwise lisp compilation can result in 0-byte files

    args = %W[
      PREFIX=#{prefix}
      DEST_PREFIX=#{prefix}
      ELISPP=share/emacs/site-lisp/proof-general
      ELISP_START=#{elisp}/site-start.d
      EMACS=#{which "emacs"}
    ]

    system "make", "install", *args

    cd "doc" do
      system "make", "info", "html"
    end
    man1.install "doc/proofgeneral.1"
    info.install "doc/ProofGeneral.info", "doc/PG-adapting.info"
    doc.install "doc/ProofGeneral", "doc/PG-adapting"
  end

  def caveats
    <<~EOS
      HTML documentation is available in: #{HOMEBREW_PREFIX}/share/doc/proof-general
    EOS
  end

  test do
    system bin/"proofgeneral", "--help"
  end
end
