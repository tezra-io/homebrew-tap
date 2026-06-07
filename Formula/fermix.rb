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
  version "0.2.0"
  license "MIT"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.2.0/fermix_macos_aarch64"
      sha256 "787a6ec6d0ea703ea71246e85e532d423df94534e3fb57d1cf4fdb50f369389c"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.2.0/fermix_macos_x86_64"
      sha256 "1455c51a782922ad99382e5a57074a427b4c30d182caebec122446f49efdc983"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.2.0/fermix_linux_aarch64"
      sha256 "7c6f7b07970115a8c00d2e897151bb0c523d75016b6b19e58cec97a8b47b858c"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.2.0/fermix_linux_x86_64"
      sha256 "61e5c075c7ba06372b2b0efaaa9873af215a8e9bdfc40c61478f1e6aaf2f0653"
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
