class Redasq < Formula
  desc "Local HTTPS MITM proxy that inspects, redacts, or blocks sensitive data sent to AI coding assistants"
  homepage "https://github.com/chaudharydeepak/redasq"
  version "0.0.1-pre"
  license "MIT"

  # Bottles are pre-built binaries — no compiler or Xcode CLT required.
  bottle do
    root_url "https://github.com/chaudharydeepak/redasq/releases/download/v0.0.1-pre"
      sha256 cellar: :any_skip_relocation, aarch64_linux: "722feb5a34e2657323a1926f3239647f94ff4f57a2f08b913dcddd1563ec04d5"
      sha256 cellar: :any_skip_relocation, arm64_sequoia: "2215b9948e0452e20f282103f888f49ed9e8e019b39412e3f514563242b459ed"
      sha256 cellar: :any_skip_relocation, arm64_sonoma: "a741e6973b55d229f4e16868c2e0c2c1cbd518e2f42b5093a3b4c266e41216f5"
      sha256 cellar: :any_skip_relocation, arm64_ventura: "a741e6973b55d229f4e16868c2e0c2c1cbd518e2f42b5093a3b4c266e41216f5"
      sha256 cellar: :any_skip_relocation, sequoia: "47139bb74c844920336b0b16e0c9ffab8fe267b180ad3920b2fea1f93dcd3f07"
      sha256 cellar: :any_skip_relocation, sonoma: "e15cd9b3e84bd7549a2fa90aa01d676c3dd873ff7936a87ff9fffe083c17ff8a"
      sha256 cellar: :any_skip_relocation, ventura: "12609a7ba39daf74b464ce8ae023201858dbcd0d096bca291cd763e56cf2895a"
      sha256 cellar: :any_skip_relocation, x86_64_linux: "04f147542ebf176d0ef9b94e8e0db132ca7d4157d5e4d736bb0135c7a82fab53"    end

  # Fallback source build for OS versions not covered by a bottle.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/chaudharydeepak/redasq/releases/download/v0.0.1-pre/redasq-darwin-arm64.tar.gz"
      sha256 "ce3b26bdbb527a0da602dbb0f46fd424f68cb0249797c703c4e66f0d2df2b16c"
    else
      url "https://github.com/chaudharydeepak/redasq/releases/download/v0.0.1-pre/redasq-darwin-amd64.tar.gz"
      sha256 "e244a75b0715d3ce42af8d3529e19c6c994b783f43e43880a962d779655027f5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/chaudharydeepak/redasq/releases/download/v0.0.1-pre/redasq-linux-arm64.tar.gz"
      sha256 "a9cc2c2d2653e24ed1b87c2118fe36d5952d2bca1c17906d6512cb35ce7f31b7"
    else
      url "https://github.com/chaudharydeepak/redasq/releases/download/v0.0.1-pre/redasq-linux-amd64.tar.gz"
      sha256 "3044f30f60bf792b10f8ec21c20fe75b912406d1b733a69e93c32149be523794"
    end
  end

  def install
    bin.install "redasq"
  end

  service do
    run [opt_bin/"redasq"]
    keep_alive true
    log_path var/"log/redasq.log"
    error_log_path var/"log/redasq.log"
  end

  def caveats
    <<~EOS
      Redasq intercepts AI coding assistant traffic (Claude Code, Copilot, etc.)
      and lets you inspect, redact, or block sensitive data before it leaves your machine.

      ── Quick start ──────────────────────────────────────────────────────────
      1. Start the proxy (runs on :8080, dashboard on :7778):
           redasq
         Or run it as a background service:
           brew services start redasq

      2. Point your shell at the proxy (add to ~/.zshrc or ~/.bashrc):
           export HTTP_PROXY=http://localhost:8080
           export HTTPS_PROXY=http://localhost:8080
           export NO_PROXY=localhost,127.0.0.1

      3. Open the dashboard:
           http://localhost:7778

      ── CA certificate (browser inspection only) ─────────────────────────────
      CLI tools (Claude Code, Copilot) work without trusting the cert.
      For browser (Chrome/Safari) inspection, trust the generated CA:

        sudo security add-trusted-cert -d -r trustRoot \
          -k /Library/Keychains/System.keychain \
          ~/.redasq/ca.crt

      The cert is auto-generated on first run at ~/.redasq/ca.crt
      ─────────────────────────────────────────────────────────────────────────
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/redasq --version")
  end
end
