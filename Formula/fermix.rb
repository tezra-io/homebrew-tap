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
  version "0.10.2"
  license "MIT"

  # The daemon shells out to cosign to verify every plugin's signature before
  # install; without it on PATH, plugin installs fail. Pull it in so brew users
  # have it. (bump.sh rewrites only version/url/sha256, so this line survives.)
  depends_on "cosign"

  # Bumper rewrites both blocks. Keep target strings in sync with
  # apps/fermix_core/lib/fermix/cli/upgrade/manifest.ex.
  on_macos do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.10.2/fermix_macos_aarch64"
      sha256 "04088611c68cf58d6f569c8a1315b9ce52b699b5ac9e1fb1b2edc251f7bbf28d"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.10.2/fermix_macos_x86_64"
      sha256 "e53f40b835349917da8d0c177e3a857f1741153bbd52e1b35ac4434015b124a1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/tezra-io/fermix/releases/download/v0.10.2/fermix_linux_aarch64"
      sha256 "bf8c4fc33b046e527bf97b5c6a82547a349ef78e553cac8ba193bacb7f4f2271"
    end

    on_intel do
      url "https://github.com/tezra-io/fermix/releases/download/v0.10.2/fermix_linux_x86_64"
      sha256 "1dc787dcf1bb25d20506bb5b31f866f0cb2c37575238644302fd6ecc31637a80"
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
