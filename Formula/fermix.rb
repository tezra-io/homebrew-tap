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
  version "0.4.2"
  license "MIT"

  # The daemon shells out to cosign to verify every plugin's signature before
  # install; without it on PATH, plugin installs fail. Pull it in so brew users
  # have it. (bump.sh rewrites only version/url/sha256, so this line survives.)
  depends_on "cosign"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.4.2/fermix_macos_aarch64"
      sha256 "d1cb01a595121fc01b62832f236d72d9052fec3442c22211c5c2f35096ef6007"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.4.2/fermix_macos_x86_64"
      sha256 "653bb2732ac908326e0d8aea858c87cc55ce3440836e2cdbcd34bf7142ac8829"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.4.2/fermix_linux_aarch64"
      sha256 "3e25380c66126ee309c771b0957fcfae21ab6bbaec4ec9fa29da33e97b1d0dec"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.4.2/fermix_linux_x86_64"
      sha256 "a92f385903d3dc4353d5982be731b6388f0ebd33df9cc0b6bc67726afbef542c"
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
