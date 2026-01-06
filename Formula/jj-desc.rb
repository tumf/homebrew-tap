class JjDesc < Formula
  desc "Generate jj commit descriptions using LLM"
  homepage "https://github.com/tumf/jj-desc"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tumf/jj-desc/releases/download/v0.2.0/jj-desc-aarch64-apple-darwin.tar.xz"
      sha256 "b2fecc6776e55be9ccd937ab3e7f6ff2c9ad24bb4d9329576fe55043e56a5141"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tumf/jj-desc/releases/download/v0.2.0/jj-desc-x86_64-apple-darwin.tar.xz"
      sha256 "abf7e58857f59a11503c990fb07978d5bacc6081d29bf73eda56d13082816579"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tumf/jj-desc/releases/download/v0.2.0/jj-desc-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "110eeb176761bf76a16bd22f9be2abb44fb72888b0b4bef6ee47f804a30ec0e9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tumf/jj-desc/releases/download/v0.2.0/jj-desc-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8c8377723fbb9733a6eb4517d296bd448bb85bd560ee4a9acbe1497618a3b846"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "jj-desc" if OS.mac? && Hardware::CPU.arm?
    bin.install "jj-desc" if OS.mac? && Hardware::CPU.intel?
    bin.install "jj-desc" if OS.linux? && Hardware::CPU.arm?
    bin.install "jj-desc" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
