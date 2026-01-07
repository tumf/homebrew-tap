class JjDesc < Formula
  desc "Generate jj commit descriptions using LLM"
  homepage "https://github.com/tumf/jj-desc"
  version "0.4.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tumf/jj-desc/releases/download/v0.4.3/jj-desc-aarch64-apple-darwin.tar.xz"
      sha256 "759c1d740be87b807baa6a4c0a85e47903da7817fcff3b20c4cff0fc2843b4a4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tumf/jj-desc/releases/download/v0.4.3/jj-desc-x86_64-apple-darwin.tar.xz"
      sha256 "02eca9ccc4d4c6f394f7b7acef30ccf86b6319df4757a425fd0851290effd8ec"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tumf/jj-desc/releases/download/v0.4.3/jj-desc-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "97800306a093b9f53b74ce520fef696ba94134fff016ca5317075c776cc0a26a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tumf/jj-desc/releases/download/v0.4.3/jj-desc-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cf8fed41f1622e7d62796c2dc5d836a27524e9cf0a83c27a231c8c8af37a4adf"
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
