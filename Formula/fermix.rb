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
  version "0.17.0"
  license "MIT"

  # The daemon shells out to cosign to verify every plugin's signature before
  # install; without it on PATH, plugin installs fail. Pull it in so brew users
  # have it. (bump.sh rewrites only version/url/sha256, so this line survives.)
  depends_on "cosign"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.17.0/fermix_macos_aarch64"
      sha256 "662ea844aa92c5f309b960fd637d14f8ab5e66d156cf1b4f65848c17d188e0b5"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.17.0/fermix_macos_x86_64"
      sha256 "16abe0cde6aee794260ee640a8bbc2b956c957581be4fd30ebe4deab2f7fcda1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.17.0/fermix_linux_aarch64"
      sha256 "e15ae8094510f4f88af740a2ce06919e6d0b9b6917bf1031604225683a954d96"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.17.0/fermix_linux_x86_64"
      sha256 "5bca746600c8066ad2cb66d9a3c3cd21189d4ef6414acfbaf7ff1191cfaaa7ca"
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
