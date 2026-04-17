class PromptGuard < Formula
  desc "Local HTTPS MITM proxy that inspects, redacts, or blocks sensitive data sent to AI coding assistants"
  homepage "https://github.com/chaudharydeepak/prompt-guard"
  version "0.1.7-pre"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/chaudharydeepak/prompt-guard/releases/download/v0.1.7-pre/prompt-guard-darwin-arm64.tar.gz"
      sha256 "ef1828d5f09aaf2c3d717959344c44b427d34290a1bbabb75efe1dd67910afcc"
    else
      url "https://github.com/chaudharydeepak/prompt-guard/releases/download/v0.1.7-pre/prompt-guard-darwin-amd64.tar.gz"
      sha256 "ad6dd1d084e72f21e182d0ae71573c651ae3112df0955ff428de79a13ee7f165"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/chaudharydeepak/prompt-guard/releases/download/v0.1.7-pre/prompt-guard-linux-arm64.tar.gz"
      sha256 "cb62cb7f1a92c96082d10a3f78b511067a09a04f3602339e522e62d2cf8a4fa8"
    else
      url "https://github.com/chaudharydeepak/prompt-guard/releases/download/v0.1.7-pre/prompt-guard-linux-amd64.tar.gz"
      sha256 "761a7f416e12c23b80cd3e705d9f1446caedff4617bcd207b323aad493afb676"
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

  test do
    assert_match version.to_s, shell_output("#{bin}/prompt-guard --version 2>&1", 1)
  end
end
