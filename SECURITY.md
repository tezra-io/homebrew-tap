# Security Policy

## Reporting a vulnerability

**Please do not open a public issue for security vulnerabilities.**

Report privately by email to **[security@tezra.io](mailto:security@tezra.io)**.
The same address covers every Fermix repository.

Please include:

- a description of the issue and its impact,
- steps to reproduce (or a proof of concept),
- the affected version / commit, and
- any suggested remediation.

We aim to acknowledge reports within a few days and will coordinate a fix and
disclosure timeline with you. Never include real secrets (API keys, tokens) in
a report — redact them.

## Supported versions

The formula and the cask track the latest Fermix releases; the release
automation bumps them.

## Scope

This tap holds the Homebrew formula for the Fermix engine and the cask for the
macOS app. Report problems with what they download or verify here too, such
as a URL or checksum that does not match the release.

For the Fermix engine's own boundary (secret handling, the sandbox, channel
ingress, signed upgrades), see the [Fermix security policy](https://github.com/tezra-io/fermix/blob/main/SECURITY.md).
