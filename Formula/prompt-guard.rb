class PromptGuard < Formula
  desc "Local HTTPS MITM proxy that inspects, redacts, or blocks sensitive data sent to AI coding assistants"
  homepage "https://github.com/chaudharydeepak/prompt-guard"
  version "0.1.9-pre"
  license "MIT"

  # Bottles are pre-built binaries — no compiler or Xcode CLT required.
  bottle do
    root_url "https://github.com/chaudharydeepak/prompt-guard/releases/download/v0.1.9-pre"
      sha256 cellar: :any_skip_relocation, aarch64_linux: "766a5b8606b9dc55a65c38724a20b69c91836aadb8888afacb0e4486ef88f68d"
      sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e6773ef7e9ad6a4ee30c63a15efd687c7058299971118786158349e5e041d61"
      sha256 cellar: :any_skip_relocation, arm64_sonoma: "d014ecfb11c27da5802050ba4ee0027d08b5d32851512d4d6c5b4d59816c898b"
      sha256 cellar: :any_skip_relocation, arm64_ventura: "d014ecfb11c27da5802050ba4ee0027d08b5d32851512d4d6c5b4d59816c898b"
      sha256 cellar: :any_skip_relocation, sequoia: "6fd763fb114049452acbacde97030db4383a62f7faed4c4b5651731f962ac4e4"
      sha256 cellar: :any_skip_relocation, sonoma: "a1d67aabfe076b43cee13da7b55ad0234a716a094a4f52ea5766b1512aa49938"
      sha256 cellar: :any_skip_relocation, ventura: "a1d67aabfe076b43cee13da7b55ad0234a716a094a4f52ea5766b1512aa49938"
      sha256 cellar: :any_skip_relocation, x86_64_linux: "40c91c3343e8e6261272c5d3a4e325c338da521b08f2db1d2a7595953c6baf6e"    end

  # Fallback source build for OS versions not covered by a bottle.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/chaudharydeepak/prompt-guard/releases/download/v0.1.9-pre/prompt-guard-darwin-arm64.tar.gz"
      sha256 "dc7ed96de1e136a47a6a5bbf03a5754044c676f2761be62b8d0ab997a88cf99f"
    else
      url "https://github.com/chaudharydeepak/prompt-guard/releases/download/v0.1.9-pre/prompt-guard-darwin-amd64.tar.gz"
      sha256 "add90130c51e422e4a3f184aa87d4bff183f37c6ebe325fe614a5af0fa4cdbdd"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/chaudharydeepak/prompt-guard/releases/download/v0.1.9-pre/prompt-guard-linux-arm64.tar.gz"
      sha256 "a284e608862a500680a0d05e4339d74452070494d01759aa15cba9fd0d1a00fd"
    else
      url "https://github.com/chaudharydeepak/prompt-guard/releases/download/v0.1.9-pre/prompt-guard-linux-amd64.tar.gz"
      sha256 "9530ab0a968b2b390d034088850c35b36dda326a694c6db55bf3faa46a07af3b"
    end
  end

  def install
    bin.install "prompt-guard"
  end

  service do
    run [opt_bin/"prompt-guard"]
    keep_alive true
    log_path var/"log/prompt-guard.log"
    error_log_path var/"log/prompt-guard.log"
  end

  def caveats
    <<~EOS
      Prompt Guard intercepts AI coding assistant traffic (Claude Code, Copilot, etc.)
      and lets you inspect, redact, or block sensitive data before it leaves your machine.

      ── Quick start ──────────────────────────────────────────────────────────
      1. Start the proxy (runs on :8080, dashboard on :7778):
           prompt-guard
         Or run it as a background service:
           brew services start prompt-guard

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
          ~/.prompt-guard/ca.crt

      The cert is auto-generated on first run at ~/.prompt-guard/ca.crt
      ─────────────────────────────────────────────────────────────────────────
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prompt-guard --version")
  end
end
