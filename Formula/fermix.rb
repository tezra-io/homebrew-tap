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
  version "0.6.0"
  license "MIT"

  # The daemon shells out to cosign to verify every plugin's signature before
  # install; without it on PATH, plugin installs fail. Pull it in so brew users
  # have it. (bump.sh rewrites only version/url/sha256, so this line survives.)
  depends_on "cosign"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.6.0/fermix_macos_aarch64"
      sha256 "e0bfb93fae7f164961becfe5902edf291675281a1b8b105f4dec711c1a088c2f"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.6.0/fermix_macos_x86_64"
      sha256 "0636724cb93391c5781570b885a8e4c95f6340f8983f63b9073f637d9402a9cb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.6.0/fermix_linux_aarch64"
      sha256 "ddc6a61c5fde9916d601e2dc330437a2f4199661483ba01c0de648603bebe91b"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.6.0/fermix_linux_x86_64"
      sha256 "93c6d3607e005fb360b0b5c743ab76dad9f3792849efd4d3432e832683795c24"
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
