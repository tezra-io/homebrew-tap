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
  version "0.11.0"
  license "MIT"

  # The daemon shells out to cosign to verify every plugin's signature before
  # install; without it on PATH, plugin installs fail. Pull it in so brew users
  # have it. (bump.sh rewrites only version/url/sha256, so this line survives.)
  depends_on "cosign"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.11.0/fermix_macos_aarch64"
      sha256 "250b18c6997e7fb0e45c5dc97f0e4752ca809296bfcd3b6e6dee4e8a8a1c973d"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.11.0/fermix_macos_x86_64"
      sha256 "1c6d4c14bcfd468e4ea5d0e89d1719759700ed234d5d55f90e27e5dac53cc2b7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.11.0/fermix_linux_aarch64"
      sha256 "a77b352d2ccc4b473b74abeea2f9f206c8d4a22177a421cc0eb22ccac5dff80d"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.11.0/fermix_linux_x86_64"
      sha256 "191ef31140780878d613215e75bceee5c88651993349e13ec30807e0627e47b5"
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
