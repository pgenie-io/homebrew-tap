# homebrew-tap

Homebrew tap for [pGenie](https://pgenie.io) — a type-safe PostgreSQL client code generator.

## Installation

Add the tap and install the `pgn` CLI tool in one command:

```sh
brew install pgenie-io/tap/pgn
```

The formula installs a pre-built binary for your platform's architecture
(macOS Apple Silicon, macOS Intel, or Linux x64). Pre-built binaries now
dynamically link against the PostgreSQL client library `libpq` instead of
statically linking it. When you install via Homebrew, `libpq` will be pulled
in as a dependency automatically. If you use the Linux binary outside Homebrew
(or encounter issues on Debian/Ubuntu), make sure the `libpq5` package is
installed (e.g. `sudo apt install libpq5`).

### Build from source

To compile from the latest development version instead, pass `--HEAD`:

```sh
brew install --HEAD pgenie-io/tap/pgn
```

This builds from the `master` branch using the Haskell toolchain
(`ghc` + `cabal-install`) and links against Homebrew's `libpq`. The first
build can take several minutes while Haskell dependencies are compiled.

## Usage

```sh
pgn --help
```

Full documentation is available at [pgenie.io/docs](https://pgenie.io/docs/).

