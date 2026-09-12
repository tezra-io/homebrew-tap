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
  version "0.10.3"
  license "MIT"

  # The daemon shells out to cosign to verify every plugin's signature before
  # install; without it on PATH, plugin installs fail. Pull it in so brew users
  # have it. (bump.sh rewrites only version/url/sha256, so this line survives.)
  depends_on "cosign"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.10.3/fermix_macos_aarch64"
      sha256 "403ce449a8dd4981d333ac3d9032420d6a348bbff4a54596b7f15cc95f45178b"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.10.3/fermix_macos_x86_64"
      sha256 "7f3f3f25becfd144730adf0175a0355738b0d4ac4d45df0fe51e904ef197618f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.10.3/fermix_linux_aarch64"
      sha256 "95d64b60968af03b6a81933c8a74a0277962e23a784da469466769810e9adde4"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.10.3/fermix_linux_x86_64"
      sha256 "f30e9d1c9ce88f6c3f61b4cbeda2478786431ba3d31f78a289a9ccb85d19a59c"
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
