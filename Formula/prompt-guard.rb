class PromptGuard < Formula
  desc "Local HTTPS MITM proxy that inspects, redacts, or blocks sensitive data sent to AI coding assistants"
  homepage "https://github.com/chaudharydeepak/prompt-guard"
  version "0.1.8-pre"
  license "MIT"

  # Bottles are pre-built binaries — no compiler or Xcode CLT required.
  bottle do
    root_url "https://github.com/chaudharydeepak/prompt-guard/releases/download/v0.1.8-pre"
      sha256 cellar: :any_skip_relocation, aarch64_linux: "69caec401053a74041db6e73ece641f80df768bfdd028f12b32481a6afe59801"
      sha256 cellar: :any_skip_relocation, arm64_sequoia: "763d06dc2da2b31d22f498f1fc483067129e9838e485d0d47f8d2bd77368c35a"
      sha256 cellar: :any_skip_relocation, arm64_sonoma: "9507b996f906ac1fb338a81ed23ae80c0b28197268d97793b11e69c5af62856e"
      sha256 cellar: :any_skip_relocation, arm64_ventura: "9507b996f906ac1fb338a81ed23ae80c0b28197268d97793b11e69c5af62856e"
      sha256 cellar: :any_skip_relocation, sequoia: "0d7f4d5d216456c997ed99fa661834d7d0c6030e2cb96c1646a982ad74eeb49d"
      sha256 cellar: :any_skip_relocation, sonoma: "861b2fd9bbaf50830d5859026fb2a75acebcae1dadb93691158e38c61c0fc53c"
      sha256 cellar: :any_skip_relocation, ventura: "861b2fd9bbaf50830d5859026fb2a75acebcae1dadb93691158e38c61c0fc53c"
      sha256 cellar: :any_skip_relocation, x86_64_linux: "c6451fe8a8b81c3c1f0c7b78db84641c6e6fb98ef6c0bc868258e35d48765e64"    end

  # Fallback source build for OS versions not covered by a bottle.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/chaudharydeepak/prompt-guard/releases/download/v0.1.8-pre/prompt-guard-darwin-arm64.tar.gz"
      sha256 "9669d530606481ce7e89471c4bf00f27a890d5051c3067445a82aade908a2bc2"
    else
      url "https://github.com/chaudharydeepak/prompt-guard/releases/download/v0.1.8-pre/prompt-guard-darwin-amd64.tar.gz"
      sha256 "9bc26275733f82511494c27d8b4a2481ab7cee22ab8928184cdd991fad6343e0"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/chaudharydeepak/prompt-guard/releases/download/v0.1.8-pre/prompt-guard-linux-arm64.tar.gz"
      sha256 "29148397bb6b05d5bb1d0bc2996e11be43611e96c0ed8623aaba83877425205e"
    else
      url "https://github.com/chaudharydeepak/prompt-guard/releases/download/v0.1.8-pre/prompt-guard-linux-amd64.tar.gz"
      sha256 "1bd1959acc1f446bf02e5717cc56a3a1f5706265e558aa650a9ec2cacb704be8"
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
