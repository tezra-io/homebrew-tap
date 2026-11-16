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
  version "0.20.0"
  license "MIT"

  # The daemon shells out to cosign to verify every plugin's signature before
  # install; without it on PATH, plugin installs fail. Pull it in so brew users
  # have it. (bump.sh rewrites only version/url/sha256, so this line survives.)
  depends_on "cosign"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.20.0/fermix_macos_aarch64"
      sha256 "41ebcebb2ce979d18b731deadb35532e35662252831ce08e9d9d711aaa429880"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.20.0/fermix_macos_x86_64"
      sha256 "740f69486f1d2eb05d3c1d7aaa7a7cb4605a440647c1c9a4a2bd3aa81198febc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.20.0/fermix_linux_aarch64"
      sha256 "603106190447109c72642b6e432b53ef6022b288646ac9d54106e10b590bba87"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.20.0/fermix_linux_x86_64"
      sha256 "444a3a364c9218ad0f1a0729e3bfecd0826ffaef5d8f7ed4f36d53c4a358e3fb"
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
