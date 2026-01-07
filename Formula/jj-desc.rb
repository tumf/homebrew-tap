class JjDesc < Formula
  desc "Generate jj commit descriptions using LLM"
  homepage "https://github.com/tumf/jj-desc"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tumf/jj-desc/releases/download/v0.4.0/jj-desc-aarch64-apple-darwin.tar.xz"
      sha256 "d2d74a3838c360daa694a2a3e4ff6cd3811e5ccd682a8e4af6322a69b2c1f4ac"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tumf/jj-desc/releases/download/v0.4.0/jj-desc-x86_64-apple-darwin.tar.xz"
      sha256 "7a92223c68d1ee79645ad8708abd7e475fb4e7421a02bf40e21d87495d6e4e28"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tumf/jj-desc/releases/download/v0.4.0/jj-desc-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "49f6df5d3c13fa13c6e3af9c86f8bef338bc2812cd10d9a262514232fc224e1f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tumf/jj-desc/releases/download/v0.4.0/jj-desc-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "876ad5496f6d7a9724a2a8dcd8e5f7926884899c5bb31024b984365d7da2bb56"
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
