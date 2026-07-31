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
  version "0.7.0"
  license "MIT"

  # The daemon shells out to cosign to verify every plugin's signature before
  # install; without it on PATH, plugin installs fail. Pull it in so brew users
  # have it. (bump.sh rewrites only version/url/sha256, so this line survives.)
  depends_on "cosign"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.7.0/fermix_macos_aarch64"
      sha256 "316f15e08df1a9ed75ff841ac3636a3f65e0ca3fa3ebb007b057cf4ee4fe2c4f"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.7.0/fermix_macos_x86_64"
      sha256 "bc1c5196f79291bacf387de9fa53bde7faf36b0986457ad1872972c9a76491c8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.7.0/fermix_linux_aarch64"
      sha256 "04ab23c8f048a9f7336d0a554e3b54775bb1e258d5b8dd0b4a127f3a8c287e17"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.7.0/fermix_linux_x86_64"
      sha256 "83abd5ea11e15f9f827c7f3bdd7a0790931ab1d64a0669cd8eb4a941c28a8f66"
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
