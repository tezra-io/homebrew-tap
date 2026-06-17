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
  version "0.3.1"
  license "MIT"

  # The daemon shells out to cosign to verify every plugin's signature before
  # install; without it on PATH, plugin installs fail. Pull it in so brew users
  # have it. (bump.sh rewrites only version/url/sha256, so this line survives.)
  depends_on "cosign"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.3.1/fermix_macos_aarch64"
      sha256 "905a710277c6468002f033997d04dff79089db093de69e6a53f0effbcf9b9c1a"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.3.1/fermix_macos_x86_64"
      sha256 "bc85681043c987f354cff22972fc925e6f72f20d71460af9094bd39aff031862"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.3.1/fermix_linux_aarch64"
      sha256 "0ebca8370983c2d7ea9f271470015b49576dafe0c6e2c731e6c890c9b1ade238"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.3.1/fermix_linux_x86_64"
      sha256 "e1cfc90736dcd0b85d18ee737303830bfe1734780c65b8a0b8cf80bb724f8e24"
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
