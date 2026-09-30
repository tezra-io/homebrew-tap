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
  version "0.12.0"
  license "MIT"

  # The daemon shells out to cosign to verify every plugin's signature before
  # install; without it on PATH, plugin installs fail. Pull it in so brew users
  # have it. (bump.sh rewrites only version/url/sha256, so this line survives.)
  depends_on "cosign"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.12.0/fermix_macos_aarch64"
      sha256 "b324d570d9dafb54be7fa79dbfeb53ad2956de5321bb1fc375e2e3f23937e895"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.12.0/fermix_macos_x86_64"
      sha256 "15cdee67ac3ebe2488436c195201a4b207a3b2dc03d94012b680f65d93bc0dad"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.12.0/fermix_linux_aarch64"
      sha256 "a36e6796a0a8ffce79061bc2224cde8861b5379dc8e5ba62cceafe294e7450b2"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.12.0/fermix_linux_x86_64"
      sha256 "68f0b289055ff5a82154ce744eddb0b4bc986e7144c0e4adabf4115df76e9d53"
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
