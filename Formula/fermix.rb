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
  version "0.2.2"
  license "MIT"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.2.2/fermix_macos_aarch64"
      sha256 "9e4d123635c8eb0aadda33e738f5a8b1ead5e0bf69fa982f11eabeb777f5150f"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.2.2/fermix_macos_x86_64"
      sha256 "6dbcffc57c8465f0e14a6bd58973e898ef86ff5c2b56f3a80993580675067e43"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.2.2/fermix_linux_aarch64"
      sha256 "40f1eae0833b3c98c9d4c982516d223aeaf197a80b6cddcb00c1bbbe6068f3e9"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.2.2/fermix_linux_x86_64"
      sha256 "dc5849bf4d7e6c0b358737dea02551708d9ed03fe162191a056c9e59d86ab327"
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
