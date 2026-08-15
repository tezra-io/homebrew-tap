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
  version "0.9.0"
  license "MIT"

  # The daemon shells out to cosign to verify every plugin's signature before
  # install; without it on PATH, plugin installs fail. Pull it in so brew users
  # have it. (bump.sh rewrites only version/url/sha256, so this line survives.)
  depends_on "cosign"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.9.0/fermix_macos_aarch64"
      sha256 "6e72892ebe9e78dbe715e3a0d908734c2935d715a217ece8c593b1c3ab17f995"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.9.0/fermix_macos_x86_64"
      sha256 "105cf3f35738a34f2807b22f51cf8748c14e4d30f1504c11781023dda83b0e47"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.9.0/fermix_linux_aarch64"
      sha256 "356db9e01b865dac794dca087350aee0f9f9906cf3df32409fef6a2c5f478711"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.9.0/fermix_linux_x86_64"
      sha256 "0830f2126c565e4c167af5b19241be98997d3347d2c6f42950f7cfcef4575283"
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
