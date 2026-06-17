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
  version "0.3.0"
  license "MIT"

  # The daemon shells out to cosign to verify every plugin's signature before
  # install; without it on PATH, plugin installs fail. Pull it in so brew users
  # have it. (bump.sh rewrites only version/url/sha256, so this line survives.)
  depends_on "cosign"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.3.0/fermix_macos_aarch64"
      sha256 "5a1a241592b8988b09daaab79e17f2712e6ce83e28dace1d270d280731fc90d4"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.3.0/fermix_macos_x86_64"
      sha256 "d8d1a701419b5a4f8c9a3f8f68c4dbd33c65c69ae303edd0bf3e339c5b107e2f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.3.0/fermix_linux_aarch64"
      sha256 "27f5cf0e12c7a17e089a08a7b85bd60e3cef48938357f190a7db8c5fb998ff71"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.3.0/fermix_linux_x86_64"
      sha256 "fe6eda106c933588e88ea91352cec553216926973605af619a39355c90aa463e"
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
