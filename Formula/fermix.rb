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
  version "0.5.5"
  license "MIT"

  # The daemon shells out to cosign to verify every plugin's signature before
  # install; without it on PATH, plugin installs fail. Pull it in so brew users
  # have it. (bump.sh rewrites only version/url/sha256, so this line survives.)
  depends_on "cosign"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.5/fermix_macos_aarch64"
      sha256 "42d0617910f53a00cae2eadae64afe9f03fcb13170ab6f5c558bf7dc860cdd13"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.5/fermix_macos_x86_64"
      sha256 "ff2d5b447a86b997fdc07014508248ee742d29483705b8d3721421e70c93a02d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.5/fermix_linux_aarch64"
      sha256 "f27d3f29fcd188a546b44aca614b2fbb5a39bc775ddd848d300d6c6f3bb51f21"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.5/fermix_linux_x86_64"
      sha256 "b4ec8c02a6b0c4a53ad654dca0312e701cec16b631e42e7df86632c70ffa8df9"
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
