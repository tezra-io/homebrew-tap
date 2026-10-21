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
  version "0.16.0"
  license "MIT"

  # The daemon shells out to cosign to verify every plugin's signature before
  # install; without it on PATH, plugin installs fail. Pull it in so brew users
  # have it. (bump.sh rewrites only version/url/sha256, so this line survives.)
  depends_on "cosign"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.16.0/fermix_macos_aarch64"
      sha256 "7fa3fea48285a39cabbff5af1ea2a168ba6828fcdfd85632891ec900d91cd78c"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.16.0/fermix_macos_x86_64"
      sha256 "af2f53b84f4bdf904083720920ed20a26c8f518ce9b37c4d3e67cc82ac44e2e3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.16.0/fermix_linux_aarch64"
      sha256 "64b5bb56d5ce8f342d34e49f87ade0517556131285d8bed9fc23e1eafaba1f87"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.16.0/fermix_linux_x86_64"
      sha256 "677c979e33421a5548338d45fca5654eb9dbd8acbdc634b3a214425220304a05"
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
