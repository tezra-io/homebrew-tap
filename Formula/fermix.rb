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
  version "0.10.5"
  license "MIT"

  # The daemon shells out to cosign to verify every plugin's signature before
  # install; without it on PATH, plugin installs fail. Pull it in so brew users
  # have it. (bump.sh rewrites only version/url/sha256, so this line survives.)
  depends_on "cosign"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.10.5/fermix_macos_aarch64"
      sha256 "0d7bce6ad4bf2a792fc273e51bcd79ee23cd98772ca5675b5fa9316717a2d19c"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.10.5/fermix_macos_x86_64"
      sha256 "ac1cdd3d57847c68d8666622acb058bfaab02f49e205f32ff3479dd1c9d948f6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.10.5/fermix_linux_aarch64"
      sha256 "2a16dacd8f7a90dd97a7cce4b1bf809bf7ce95295fba878d3e3635ff195adefa"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.10.5/fermix_linux_x86_64"
      sha256 "922a146d979d9db82e2ee89f56808e5462f5320473df5695ca38476e3d1281d8"
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
