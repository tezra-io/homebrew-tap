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
  version "0.5.7"
  license "MIT"

  # The daemon shells out to cosign to verify every plugin's signature before
  # install; without it on PATH, plugin installs fail. Pull it in so brew users
  # have it. (bump.sh rewrites only version/url/sha256, so this line survives.)
  depends_on "cosign"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.7/fermix_macos_aarch64"
      sha256 "ff81cb2c957d46b654d41dd3486678010e254b8dd286d0da43a3a6fb19d600ab"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.7/fermix_macos_x86_64"
      sha256 "05386cd82d9b4376e1e234b41aa3bd7aa3c3af5ab9cb08fcbb7d65ea7340c992"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.7/fermix_linux_aarch64"
      sha256 "d36f4490beab121d652c941a8834c86172a2bf96ce0602cb174850580b0c61ad"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.7/fermix_linux_x86_64"
      sha256 "453026f7f56d2452042d493709834973442debfd94038a74cdd4ca9c4a3369ab"
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
