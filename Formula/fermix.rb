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
  version "0.5.0"
  license "MIT"

  # The daemon shells out to cosign to verify every plugin's signature before
  # install; without it on PATH, plugin installs fail. Pull it in so brew users
  # have it. (bump.sh rewrites only version/url/sha256, so this line survives.)
  depends_on "cosign"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.0/fermix_macos_aarch64"
      sha256 "1190b36ca51032404c3405914275b38be2e5d92a05d38b0d798189f6d73df4fb"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.0/fermix_macos_x86_64"
      sha256 "b0273449bfe096c2b723675e333f38e031336a118443fee06c723a63896aff56"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.0/fermix_linux_aarch64"
      sha256 "5615438eca94690e03a4f4b292d6fbfc2ed5e36b78d87edf3cf0da2ef3b92b01"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.0/fermix_linux_x86_64"
      sha256 "f5fb16981aecdbe72c1f6b25c443e5334f3ff0888685c7868a71e8cf6ff9d44c"
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
