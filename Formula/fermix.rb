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
  version "0.5.4"
  license "MIT"

  # The daemon shells out to cosign to verify every plugin's signature before
  # install; without it on PATH, plugin installs fail. Pull it in so brew users
  # have it. (bump.sh rewrites only version/url/sha256, so this line survives.)
  depends_on "cosign"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.4/fermix_macos_aarch64"
      sha256 "e67c60b253c15719d3c874246dd87f9dc7ecadfc543b944df0f81a492182f1e1"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.4/fermix_macos_x86_64"
      sha256 "84a177837a1f9b864e52d9e7df1eb16294642376334cb42c1c9c197af00ae137"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.4/fermix_linux_aarch64"
      sha256 "c843ad20c24cbd84a5b69077a3f3873d4fae71c75b5fcca0165f0080d2ffbebc"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.4/fermix_linux_x86_64"
      sha256 "9ddc45414bc3412a1cd0561f195f5bda3874a1fc2da9381f8e3ba87d8afd64d6"
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
