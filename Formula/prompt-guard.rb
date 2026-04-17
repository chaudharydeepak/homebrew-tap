class PromptGuard < Formula
  desc "Local HTTPS MITM proxy that inspects, redacts, or blocks sensitive data sent to AI coding assistants"
  homepage "https://github.com/chaudharydeepak/prompt-guard"
  version "0.1.10-pre"
  license "MIT"

  # Bottles are pre-built binaries — no compiler or Xcode CLT required.
  bottle do
    root_url "https://github.com/chaudharydeepak/prompt-guard/releases/download/v0.1.10-pre"
      sha256 cellar: :any_skip_relocation, aarch64_linux: "dc600ac61167ac615813789389eb78ad5f5375faf13398a46eb69dc4db872610"
      sha256 cellar: :any_skip_relocation, arm64_sequoia: "54716f27bbf1ba7ed6d52ae7182b79cd401f4f244f673050d612090be3681f8a"
      sha256 cellar: :any_skip_relocation, arm64_sonoma: "54716f27bbf1ba7ed6d52ae7182b79cd401f4f244f673050d612090be3681f8a"
      sha256 cellar: :any_skip_relocation, arm64_ventura: "8fa57d368146de9cbcd913c34ea38ba8b151b26ba9715b7c7c7413f5451a6ef5"
      sha256 cellar: :any_skip_relocation, sequoia: "769f13cb984ce2dc1ce23a80244212aadbccac461725776d361eab65d6ac9f0a"
      sha256 cellar: :any_skip_relocation, sonoma: "337c6f265cf0874d18bb17e61686aee57519094f83659b299aad7d03e510fcb4"
      sha256 cellar: :any_skip_relocation, ventura: "1e069529691f80a59970e9a8c9a3042119a578c17bb2c65f9363a7be6bf0b796"
      sha256 cellar: :any_skip_relocation, x86_64_linux: "e241b9fd5d20965010b25986272bac364f37c76331e853259e2a365842e09950"    end

  # Fallback source build for OS versions not covered by a bottle.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/chaudharydeepak/prompt-guard/releases/download/v0.1.10-pre/prompt-guard-darwin-arm64.tar.gz"
      sha256 "8994fcadcd48e062819779ac0c47e364b6d3a34c21ea9ecbe8d7ab2b1c4303d2"
    else
      url "https://github.com/chaudharydeepak/prompt-guard/releases/download/v0.1.10-pre/prompt-guard-darwin-amd64.tar.gz"
      sha256 "72796a12dc28e68bd203bef9ef3ea81c5c007c8a51cc2ef6fbb74022217495a0"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/chaudharydeepak/prompt-guard/releases/download/v0.1.10-pre/prompt-guard-linux-arm64.tar.gz"
      sha256 "a4ab41b2ca848000b6fe249615a9b9e74343af7c77b3f1f8f76bc45656c60676"
    else
      url "https://github.com/chaudharydeepak/prompt-guard/releases/download/v0.1.10-pre/prompt-guard-linux-amd64.tar.gz"
      sha256 "2d12177cbd69d74ced9c3e3b5b6f68f9d2840ce537c83f864ad036a20b5aba30"
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
