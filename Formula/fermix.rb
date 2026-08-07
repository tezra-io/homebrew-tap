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
  version "0.8.0"
  license "MIT"

  # The daemon shells out to cosign to verify every plugin's signature before
  # install; without it on PATH, plugin installs fail. Pull it in so brew users
  # have it. (bump.sh rewrites only version/url/sha256, so this line survives.)
  depends_on "cosign"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.8.0/fermix_macos_aarch64"
      sha256 "ec4432a097d11a9eb7cd0146af9e7b4994784c779b7c88e44e6e4b05dc224fe3"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.8.0/fermix_macos_x86_64"
      sha256 "90df09b6e3a3ee6c9666ab5c0b5f47274ee5b0672e8100aaba6455dd003c79b7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.8.0/fermix_linux_aarch64"
      sha256 "8069dae72d9959cb03dcb45275b2bbe5a31f39e3e6f96f2b267721268d397b5f"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.8.0/fermix_linux_x86_64"
      sha256 "f6b09a90645d4d98f8dfe2511b0e9dfa0a551d7d0fb34142f3c1d38401175566"
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
