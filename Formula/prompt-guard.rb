class PromptGuard < Formula
  desc "Local HTTPS MITM proxy that inspects, redacts, or blocks sensitive data sent to AI coding assistants"
  homepage "https://github.com/chaudharydeepak/prompt-guard"
  version "0.1.8-pre"
  license "MIT"

  # Bottles are pre-built binaries — no compiler or Xcode CLT required.
  bottle do
    root_url "https://github.com/chaudharydeepak/prompt-guard/releases/download/v0.1.8-pre"
      sha256 cellar: :any_skip_relocation, aarch64_linux: "63c509866f50124264f2c2817ab5b8431c54405a721d00f2d0492ddd8cebf40f"
      sha256 cellar: :any_skip_relocation, arm64_sequoia: "d02da9ee0f673e19a367e5060e14a9cd1845b92b3684e71acea713445aabccb7"
      sha256 cellar: :any_skip_relocation, arm64_sonoma: "8376de9d6438bc050b3d24457f379634082d1d53bc9ec12f4f3151e06920b78b"
      sha256 cellar: :any_skip_relocation, arm64_ventura: "7375d40676ba3a04d392a3fb855151eb30370e74476a14b96366f57001dab5d4"
      sha256 cellar: :any_skip_relocation, sequoia: "d2180cd0fb15f03b91fd4b5c89684eb48ee9fd8a2c40491db221dc4ec04c5c1b"
      sha256 cellar: :any_skip_relocation, sonoma: "43bb396665e77c24079de703a5fe08fa2fbea8421ddf4d166be7b97ba41232ba"
      sha256 cellar: :any_skip_relocation, ventura: "43bb396665e77c24079de703a5fe08fa2fbea8421ddf4d166be7b97ba41232ba"
      sha256 cellar: :any_skip_relocation, x86_64_linux: "2bb54884b4e30bf22e10ae7fb07c117ab0ab9cad973a267e21f18a17f1acdb12"    end

  # Fallback source build for OS versions not covered by a bottle.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/chaudharydeepak/prompt-guard/releases/download/v0.1.8-pre/prompt-guard-darwin-arm64.tar.gz"
      sha256 "15715b1f07488ab03e9dda2e75a16099883040357f4da344cd4768c9ddd22f59"
    else
      url "https://github.com/chaudharydeepak/prompt-guard/releases/download/v0.1.8-pre/prompt-guard-darwin-amd64.tar.gz"
      sha256 "f93e629331e9ff9a2f08f816faf97b3c3d5b827a3fbb7d1a93e9b476702a4052"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/chaudharydeepak/prompt-guard/releases/download/v0.1.8-pre/prompt-guard-linux-arm64.tar.gz"
      sha256 "46b03b0eb1f86cb99346b287d033ab85ae1f0c72659a462bf38bd47e5dd845c9"
    else
      url "https://github.com/chaudharydeepak/prompt-guard/releases/download/v0.1.8-pre/prompt-guard-linux-amd64.tar.gz"
      sha256 "b75d613444af7ded09b8a3a0e75521b4a1677eb0fdc624d5a31f7b2e40b16a81"
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
