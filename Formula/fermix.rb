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
  version "0.1.0"
  license "MIT"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.1.0/fermix_macos_aarch64"
      sha256 "fae35c52b0a9fb03fdc9a1e60703cf4e515a5ea57986072f82e7dddb2e3b8ce0"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.1.0/fermix_macos_x86_64"
      sha256 "72e6e374ba08e5f3db74a6cfdda3607b6acad7d5ac79c91063c784ed314a7beb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.1.0/fermix_linux_aarch64"
      sha256 "d6c7f626efb01c97d25b6cbea5866a58d1113f86db63f2e8ff818db3c709b4ff"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.1.0/fermix_linux_x86_64"
      sha256 "d73f8955287a9e0e449fbf6c1d3d492485ec198a4a13dc7d26e095e7165487df"
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
