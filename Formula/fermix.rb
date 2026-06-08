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
  version "0.2.3"
  license "MIT"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.2.3/fermix_macos_aarch64"
      sha256 "00d7777ba1aa25840890ac8f088071d22867b309ca65e5a6ecf4ad4726eaa50d"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.2.3/fermix_macos_x86_64"
      sha256 "c76f5bb533f9d4c416d727a7f7bb2572e629882da824017c5281cb1426e71ed5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.2.3/fermix_linux_aarch64"
      sha256 "516e6eaec0bea33acf0f551daa6d965076c32a93c57702adfcffc2277b037c64"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.2.3/fermix_linux_x86_64"
      sha256 "266f0aee24093883c5c49b499c8ee0b138f5292c8302bbc7ea69f2f512631e65"
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
