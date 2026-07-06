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
  version "0.5.2"
  license "MIT"

  # The daemon shells out to cosign to verify every plugin's signature before
  # install; without it on PATH, plugin installs fail. Pull it in so brew users
  # have it. (bump.sh rewrites only version/url/sha256, so this line survives.)
  depends_on "cosign"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.2/fermix_macos_aarch64"
      sha256 "7c2b395f82d4400e9ed7aa1070c5a50e2b32a54bfd3a9d1230529a3a0a8f3b66"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.2/fermix_macos_x86_64"
      sha256 "cb58f21086bff9f7cd263a8f254e9e03f3350f4baf5a0c7f5fb66cefc275b42c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.2/fermix_linux_aarch64"
      sha256 "4b9d51e86a01491a2980fea5da6cdb30d2e2f93d72d7573cd9f62ba102580694"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.2/fermix_linux_x86_64"
      sha256 "1f1b52d28052ed538be5f39565adc5777150d7f3e177bb3bab5e3b4f1944ac8b"
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
