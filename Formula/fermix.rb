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
  version "0.14.0"
  license "MIT"

  # The daemon shells out to cosign to verify every plugin's signature before
  # install; without it on PATH, plugin installs fail. Pull it in so brew users
  # have it. (bump.sh rewrites only version/url/sha256, so this line survives.)
  depends_on "cosign"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.14.0/fermix_macos_aarch64"
      sha256 "4d166cf726743fc34685904ccd6af1632de5c35b1b16969a479e4085ccef95d8"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.14.0/fermix_macos_x86_64"
      sha256 "11b57f0d99e14fe3ea42323699ba5e1ed63ef1d3dc606cd1d826dbc07b72fd27"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.14.0/fermix_linux_aarch64"
      sha256 "084c8b3a633aca5de07c742e80658b60bb0e7a150f244e7d3bcf9253fc21a7f6"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.14.0/fermix_linux_x86_64"
      sha256 "068bf96c66e8c7cd7e77135678b8cc1193d18a13d9408abe695d689272ef51cf"
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
