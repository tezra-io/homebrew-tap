# Starter Homebrew formula for fermix.
#
# This file lives in the fermix repo as a template. Publishing path:
# the release pipeline (see `.github/workflows/release.yml`) emits
# `releases.json` with the URL + sha256 for each binary; the bumper
# script `scripts/homebrew/bump.sh` (Stage 6) reads that manifest,
# rewrites the `url`/`sha256` lines below, and opens a PR against
# the `tezra-io/homebrew-fermix` tap repo. We do not publish a
# bottle in M4.8 — the binary is already statically linked, so the
# formula installs the released artifact verbatim.
#
# Manual install for testing (after a release exists):
#   brew install --build-from-source ./scripts/homebrew/fermix.rb
class Fermix < Formula
  desc "Elixir-native multi-agent AI platform"
  homepage "https://github.com/tezra-io/fermix"
  version "0.2.1"
  license "MIT"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.2.1/fermix_macos_aarch64"
      sha256 "bf98f9524db790f416c3e551a55331674c234d8ffec07da8ce5b03e66ec2ac28"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.2.1/fermix_macos_x86_64"
      sha256 "2d26046533fbcf09c7f7c7ca3e735e4c5a7e5099787402004fe71548028dce19"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.2.1/fermix_linux_aarch64"
      sha256 "6f7aa7f5066a3606de48a0b2d0aa611830a2b39d024080b774ca58107c7cde36"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.2.1/fermix_linux_x86_64"
      sha256 "c86e0556fb9af751df703dff1dd7270e884ff971a6e303f13ad0739815dc5997"
    end
  end

  def install
    bin.install Dir["fermix*"].first => "fermix"
  end

  def caveats
    <<~EOS
      To finish setup:
        fermix setup

      To install fermix as a launchd service:
        fermix service install

      To check daemon health:
        fermix doctor
    EOS
  end

  test do
    assert_match "fermix", shell_output("#{bin}/fermix version")
  end
end
