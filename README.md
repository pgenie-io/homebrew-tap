# homebrew-tap

Homebrew tap for [pGenie](https://pgenie.io) — a type-safe PostgreSQL client code generator.

## Installation

Add the tap and install the `pgn` CLI tool in one command:

```sh
brew install pgenie-io/tap/pgn
```

The formula installs a pre-built binary for your Mac's architecture (Apple
Silicon or Intel) with no additional dependencies.

### Build from source

To compile from the latest development version instead, pass `--HEAD`:

```sh
brew install --HEAD pgenie-io/tap/pgn
```

This builds from the `master` branch using the Haskell toolchain
(`ghc` + `cabal-install`) and links against Homebrew's `libpq`.  The first
build can take several minutes while Haskell dependencies are compiled.

## Usage

```sh
pgn --help
```

Full documentation is available at [pgenie.io/docs](https://pgenie.io/docs/).

