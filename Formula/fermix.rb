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
  version "0.10.4"
  license "MIT"

  # The daemon shells out to cosign to verify every plugin's signature before
  # install; without it on PATH, plugin installs fail. Pull it in so brew users
  # have it. (bump.sh rewrites only version/url/sha256, so this line survives.)
  depends_on "cosign"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.10.4/fermix_macos_aarch64"
      sha256 "f7d6f1eb2e289c7836e75cfc35e7b63c8fb5593bce286ac9b577a98a7ac97bd5"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.10.4/fermix_macos_x86_64"
      sha256 "940f3ec545d5e9c0a3f7fa19c2212c5954d855efee5a879f9d525887daebbbd5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.10.4/fermix_linux_aarch64"
      sha256 "4ddebb8dd524366d0430e917d10a14e0acd682af11d1414cfe69d969a96d3e8a"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.10.4/fermix_linux_x86_64"
      sha256 "90faaa20a22a901dd5b76606cc08a90f7d37dcb496b7df2010ed35bead7732f0"
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
