# homebrew-tap

Homebrew tap for [Tezra](https://github.com/tezra-io) tools.

## Install

```sh
brew tap tezra-io/tap
```

Then install any formula by name:

```sh
brew install fermix
```

Or in one shot:

```sh
brew install tezra-io/tap/fermix
```

## Formulas

| Formula | Project | Description |
|---------|---------|-------------|
| `fermix` | [tezra-io/fermix](https://github.com/tezra-io/fermix) | Elixir-native multi-agent AI platform |

## Upgrade

```sh
brew upgrade fermix
```

`fermix upgrade` (and other Tezra tools) will detect a Homebrew-managed
install and refuse to overwrite it; use `brew upgrade` instead.

## How this tap is updated

Each formula's `version`, `url`, and `sha256` lines are rewritten by a
release pipeline in the corresponding upstream repo. For fermix, that
is [`scripts/homebrew/bump.sh`](https://github.com/tezra-io/fermix/blob/main/scripts/homebrew/bump.sh)
in the main repo, run from the
[release workflow](https://github.com/tezra-io/fermix/blob/main/.github/workflows/release.yml).

After every release, that pipeline opens a PR against this repo with
the new version, URLs, and sha256s for all four targets (macOS
arm64/x86_64, Linux arm64/x86_64).

Do not hand-edit the `version`, `url`, or `sha256` lines — the
bumper will overwrite them on the next release.
