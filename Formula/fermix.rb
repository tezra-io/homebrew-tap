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
  version "0.4.1"
  license "MIT"

  # The daemon shells out to cosign to verify every plugin's signature before
  # install; without it on PATH, plugin installs fail. Pull it in so brew users
  # have it. (bump.sh rewrites only version/url/sha256, so this line survives.)
  depends_on "cosign"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.4.1/fermix_macos_aarch64"
      sha256 "396c4fbb5efa07a90ce74a129e3e46ea6e74067c3c781551df78481eb44d7f23"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.4.1/fermix_macos_x86_64"
      sha256 "d8988829eb93fc514c405c0b38a641c4421a90371f8717a65c016aeab5db31e6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.4.1/fermix_linux_aarch64"
      sha256 "d17127cde919a9dccf99b8e229ad21e65a69d67f433986ba4494b6e402906dc1"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.4.1/fermix_linux_x86_64"
      sha256 "fdfc76571ac3404413bc7689f56bfac7ddf2cd21ddaa1f2afcb5f44026df0b3b"
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
