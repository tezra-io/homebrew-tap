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
  version "0.5.8"
  license "MIT"

  # The daemon shells out to cosign to verify every plugin's signature before
  # install; without it on PATH, plugin installs fail. Pull it in so brew users
  # have it. (bump.sh rewrites only version/url/sha256, so this line survives.)
  depends_on "cosign"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.8/fermix_macos_aarch64"
      sha256 "987a42566269790531004499028d2bc9ad2d69c598b0ea5d8c97aed57a1d4f67"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.8/fermix_macos_x86_64"
      sha256 "d680df7838efa6b6186632caeef8a65d706681bf5079ee4efb7307b5d8eeb369"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.8/fermix_linux_aarch64"
      sha256 "08ecc535b723c7f9b276c3fbd3f856e7e9194ed5376cabc8a98dcefe3ed1f46d"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.5.8/fermix_linux_x86_64"
      sha256 "d6f0b6946de700067b31e352521a179878747f0caa6ca18177a1a6134f9c8c08"
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
