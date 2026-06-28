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
  version "0.4.0"
  license "MIT"

  # The daemon shells out to cosign to verify every plugin's signature before
  # install; without it on PATH, plugin installs fail. Pull it in so brew users
  # have it. (bump.sh rewrites only version/url/sha256, so this line survives.)
  depends_on "cosign"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.4.0/fermix_macos_aarch64"
      sha256 "6d92fd911eb15ac72e7f6d09634e5f0997b4af032971c6f0bfcdc2de75763654"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.4.0/fermix_macos_x86_64"
      sha256 "67bf9b9c26725fb23cd49d7026c82d1838969b1236905ad5225b52e210b4ca9a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.4.0/fermix_linux_aarch64"
      sha256 "57dc8e3b81de56d0fe0a07d139e73e0d1ea38ce5ae5b4dff15b234a3ba072488"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.4.0/fermix_linux_x86_64"
      sha256 "a9278dfef6f8061665dcbccd3a450c95dc4ddebdc44c5f704047a9b0c5fb7b8c"
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
