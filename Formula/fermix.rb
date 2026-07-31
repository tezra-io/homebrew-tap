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
  version "0.7.2"
  license "MIT"

  # The daemon shells out to cosign to verify every plugin's signature before
  # install; without it on PATH, plugin installs fail. Pull it in so brew users
  # have it. (bump.sh rewrites only version/url/sha256, so this line survives.)
  depends_on "cosign"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.7.2/fermix_macos_aarch64"
      sha256 "be61e6336c657ee48d294e5cb80bf3ab9145893683eb02444860849476a4e2a8"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.7.2/fermix_macos_x86_64"
      sha256 "c59c421079bb541ebd10c7fa08def52ec1b16d1e9c245426056f2c390efab979"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.7.2/fermix_linux_aarch64"
      sha256 "627aff80ebcd9c5931a3d676222ad82b338dd6491155df909704b36646bdfb9a"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.7.2/fermix_linux_x86_64"
      sha256 "4f91034d69798b504bef51a582c085de98aebd9ced3ebc09d93d15cce53817a6"
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
