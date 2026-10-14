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
  version "0.15.0"
  license "MIT"

  # The daemon shells out to cosign to verify every plugin's signature before
  # install; without it on PATH, plugin installs fail. Pull it in so brew users
  # have it. (bump.sh rewrites only version/url/sha256, so this line survives.)
  depends_on "cosign"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.15.0/fermix_macos_aarch64"
      sha256 "ea43570bf1feee271a6650ca9a83980f05fe73b45c90ce9c4e21986ff5526520"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.15.0/fermix_macos_x86_64"
      sha256 "e781e674cce48fa54bec310c29a26abd64b9d3c2832c942003396ace859e1996"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.15.0/fermix_linux_aarch64"
      sha256 "da186d1d50a463d6752cee9de08a7c665dc89267264c5a8232def4150887d875"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.15.0/fermix_linux_x86_64"
      sha256 "cec10f1dc140c4f1199849a81ef25888e748e959b7d52ef61d303286c1f3f2a3"
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
