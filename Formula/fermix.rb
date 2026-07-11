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
  version "0.5.6"
  license "MIT"

  # The daemon shells out to cosign to verify every plugin's signature before
  # install; without it on PATH, plugin installs fail. Pull it in so brew users
  # have it. (bump.sh rewrites only version/url/sha256, so this line survives.)
  depends_on "cosign"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.6/fermix_macos_aarch64"
      sha256 "bda541455880c8e8321b5c18401a9ff0c9919364883af1fefc9d7c17d8c8eaec"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.6/fermix_macos_x86_64"
      sha256 "f65afb5195e88c857dfe0e05060286c245a1b78d321d80ef1beda2749291c2ab"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.6/fermix_linux_aarch64"
      sha256 "1646e410abb476879e04afe7506ca7dd3c3b8e7b054587ac69a5b1e53cc4e829"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.6/fermix_linux_x86_64"
      sha256 "c7c236d40cde335acec2bd1109d388e36f9a6f50b8bba6546eaf05e189234481"
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
