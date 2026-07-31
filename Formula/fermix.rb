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
  version "0.7.1"
  license "MIT"

  # The daemon shells out to cosign to verify every plugin's signature before
  # install; without it on PATH, plugin installs fail. Pull it in so brew users
  # have it. (bump.sh rewrites only version/url/sha256, so this line survives.)
  depends_on "cosign"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.7.1/fermix_macos_aarch64"
      sha256 "0c2eecfe5a58f196841032f66c09018669263d6c9fb5b134a696d23e16654cf0"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.7.1/fermix_macos_x86_64"
      sha256 "6d13f16e0d21d5ce2acd3f084f21199765bc2e0a4b079263414fee490a8410ef"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.7.1/fermix_linux_aarch64"
      sha256 "c32050b6638fa4b6db53c49a8eae16d29d143918277950d4093970d6415e1b82"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.7.1/fermix_linux_x86_64"
      sha256 "abd488ec37a609b9650514147b905723567fe29714e77857d3ab743ef804c16f"
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
