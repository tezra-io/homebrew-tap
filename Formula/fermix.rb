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
  version "0.5.1"
  license "MIT"

  # The daemon shells out to cosign to verify every plugin's signature before
  # install; without it on PATH, plugin installs fail. Pull it in so brew users
  # have it. (bump.sh rewrites only version/url/sha256, so this line survives.)
  depends_on "cosign"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.1/fermix_macos_aarch64"
      sha256 "3882e8a88501e0504c6522e1e038ff3f6397753ed722b6c9d4695b674d89076a"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.1/fermix_macos_x86_64"
      sha256 "18ea3208624b92889b837f8ebf1ab955e15667a009b2462a42177cc61eb0cb38"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.1/fermix_linux_aarch64"
      sha256 "81839478f57d7b636acfe64b6fdec03bd7b6638e3c541992579132ee7990a987"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.1/fermix_linux_x86_64"
      sha256 "c1e07f5ddf12ad41bdedb882623cdbcacff78adab6189cd174df65bb201ba029"
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
