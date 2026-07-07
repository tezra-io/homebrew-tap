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
  version "0.5.3"
  license "MIT"

  # The daemon shells out to cosign to verify every plugin's signature before
  # install; without it on PATH, plugin installs fail. Pull it in so brew users
  # have it. (bump.sh rewrites only version/url/sha256, so this line survives.)
  depends_on "cosign"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.3/fermix_macos_aarch64"
      sha256 "dbdabebb3705ab3be9cc1477851b12bea94d1f76489a7b81d20822bb9a29aab3"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.3/fermix_macos_x86_64"
      sha256 "07bb5325eaacbbab4860bd88690fdfbc1f672f972d4c9f01f959d6ad013fff1b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.3/fermix_linux_aarch64"
      sha256 "5a140b6997f6f5ac550ac936976d08f7925c8709f398155d5b3125e17b81a343"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.3/fermix_linux_x86_64"
      sha256 "ea7015b080d78fa5695e4abe73816a71ff5631aac387a5266ac793275183fe2a"
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
