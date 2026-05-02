class Redasq < Formula
  desc "Local HTTPS MITM proxy that inspects, redacts, or blocks sensitive data sent to AI coding assistants"
  homepage "https://github.com/chaudharydeepak/redasq"
  version "0.1.11-pre"
  license "MIT"

  # Bottles are pre-built binaries — no compiler or Xcode CLT required.
  bottle do
    root_url "https://github.com/chaudharydeepak/redasq/releases/download/v0.1.11-pre"
      sha256 cellar: :any_skip_relocation, aarch64_linux: "0d387c08424fcb2efd7d0f9954a24182aebb3c99d57a73144f912622337a2292"
      sha256 cellar: :any_skip_relocation, arm64_sequoia: "9690fccde87c00b7ed7f1b80c161ca78aeae0eaed8622d1506dcfe25abdca2bd"
      sha256 cellar: :any_skip_relocation, arm64_sonoma: "fa51673001abb63df95d0b243d63c8371d4c5cb2a4d5e6d003668eef1737947d"
      sha256 cellar: :any_skip_relocation, arm64_ventura: "fa51673001abb63df95d0b243d63c8371d4c5cb2a4d5e6d003668eef1737947d"
      sha256 cellar: :any_skip_relocation, sequoia: "bdfcad609853b3e36e691ba612f71361970fcd0278ce43f440e856e805574fd8"
      sha256 cellar: :any_skip_relocation, sonoma: "95df18eb67ff6305f6501c78021a6b52c9dde0b69dc40c39157ca5b05f53c9b5"
      sha256 cellar: :any_skip_relocation, ventura: "95df18eb67ff6305f6501c78021a6b52c9dde0b69dc40c39157ca5b05f53c9b5"
      sha256 cellar: :any_skip_relocation, x86_64_linux: "c5c18b7da0a2f0b26aefbe39c665f8bd9ea6974506769a53e21ca99c46510ff3"    end

  # Fallback source build for OS versions not covered by a bottle.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/chaudharydeepak/redasq/releases/download/v0.1.11-pre/redasq-darwin-arm64.tar.gz"
      sha256 "67fd36516de5ab9fd799f197e62b484cdd4f532a202ef024645cfba31af67d85"
    else
      url "https://github.com/chaudharydeepak/redasq/releases/download/v0.1.11-pre/redasq-darwin-amd64.tar.gz"
      sha256 "db5ba5d685dd9514044ac65f6c6e69767e35b44d186589d3430cdc528a7c7738"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/chaudharydeepak/redasq/releases/download/v0.1.11-pre/redasq-linux-arm64.tar.gz"
      sha256 "8368a45f01d252c982fe9b6cf918856958e37b0b6ebac86af39c1c165b38f788"
    else
      url "https://github.com/chaudharydeepak/redasq/releases/download/v0.1.11-pre/redasq-linux-amd64.tar.gz"
      sha256 "027421f1278f71edf5a656f1c88a9e6f9789dff9d17c9a15d19e22b7169f850b"
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
