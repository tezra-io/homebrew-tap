# homebrew-fermix

Homebrew tap for [fermix](https://github.com/tezra-io/fermix), the
Elixir-native multi-agent AI platform.

## Install

```sh
brew install tezra-io/fermix/fermix
```

(Equivalent to `brew tap tezra-io/fermix && brew install fermix`.)

## Upgrade

```sh
brew upgrade fermix
```

`fermix upgrade` will detect that this install is managed by Homebrew
and refuse to overwrite it; use `brew upgrade` instead.

## What you get

- A statically linked single binary at `$(brew --prefix)/bin/fermix`.
- Run `fermix setup` once after install to configure providers and
  channels.
- Run `fermix service install` to register the launchd or systemd
  service unit.
- Run `fermix doctor` to validate the install.

See the [main repo](https://github.com/tezra-io/fermix) for full
documentation.

## How this tap is updated

The formula in `Formula/fermix.rb` is rewritten by
[`scripts/homebrew/bump.sh`](https://github.com/tezra-io/fermix/blob/main/scripts/homebrew/bump.sh)
in the main repo. After every release, the
[release pipeline](https://github.com/tezra-io/fermix/blob/main/.github/workflows/release.yml)
opens a PR against this repo with the new version, URLs, and
sha256s for all four targets (macOS arm64/x86_64, Linux
arm64/x86_64).

Do not hand-edit the `version`, `url`, or `sha256` lines — the
bumper will overwrite them on the next release.
