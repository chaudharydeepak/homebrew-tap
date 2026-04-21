class Redasq < Formula
  desc "Local HTTPS MITM proxy that inspects, redacts, or blocks sensitive data sent to AI coding assistants"
  homepage "https://github.com/chaudharydeepak/redasq"
  version "0.0.2-pre"
  license "MIT"

  # Bottles are pre-built binaries — no compiler or Xcode CLT required.
  bottle do
    root_url "https://github.com/chaudharydeepak/redasq/releases/download/v0.0.2-pre"
      sha256 cellar: :any_skip_relocation, aarch64_linux: "e66ec1305569ab4f3346d27e7f526ee302163e489f884c64feb7041f221efc97"
      sha256 cellar: :any_skip_relocation, arm64_sequoia: "86d5735a90e3b7720e3eb73acdd82ff3699d972828bca3ff759d281892935a76"
      sha256 cellar: :any_skip_relocation, arm64_sonoma: "205f1f78424b71c1a78e1356d835ab62dda8316c3c6c46a8b0187d5a95752612"
      sha256 cellar: :any_skip_relocation, arm64_ventura: "bff28f4c3785410d11af68e86e5090c0fffe875cfe622695821e4ea224776391"
      sha256 cellar: :any_skip_relocation, sequoia: "3202c6d8ee02909ae4ec7ea66ce6ed209846144b2e8bd6e77d8b9acbfd870f39"
      sha256 cellar: :any_skip_relocation, sonoma: "3202c6d8ee02909ae4ec7ea66ce6ed209846144b2e8bd6e77d8b9acbfd870f39"
      sha256 cellar: :any_skip_relocation, ventura: "28add3634863e08e3bff4f7b82e83cee0b32f02499a71dc317f90d7cdb8c4f92"
      sha256 cellar: :any_skip_relocation, x86_64_linux: "67a12fa6eeeed28156b26f082e10601c61d92e840b3af62ce973e7f70a5d2fa5"    end

  # Fallback source build for OS versions not covered by a bottle.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/chaudharydeepak/redasq/releases/download/v0.0.2-pre/redasq-darwin-arm64.tar.gz"
      sha256 "55b16ad450d5380c94a94029774fcef1579d6942dd0af5174f30462e72563803"
    else
      url "https://github.com/chaudharydeepak/redasq/releases/download/v0.0.2-pre/redasq-darwin-amd64.tar.gz"
      sha256 "683400037d5d5bdc91bb56570abc7f7bad204fd5e64886a8d688b4eb1892dc60"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/chaudharydeepak/redasq/releases/download/v0.0.2-pre/redasq-linux-arm64.tar.gz"
      sha256 "b74982a27791d7fc8223c28d1a204cdf87b9e8517d653859d50eda1536f86508"
    else
      url "https://github.com/chaudharydeepak/redasq/releases/download/v0.0.2-pre/redasq-linux-amd64.tar.gz"
      sha256 "8b803e4ad12788d9789e172e4b4cef89a71ea1c8021614abaa517a2b091666f6"
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
