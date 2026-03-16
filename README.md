# homebrew-tap

Homebrew tap for [pGenie](https://pgenie.io) — a type-safe PostgreSQL client code generator.

## Installation

Add the tap and install the `pgn` CLI tool in one command:

```sh
brew install --HEAD pgenie-io/tap/pgn
```

> **Note:** Until a stable release is published the formula has no versioned
> source URL, so `--HEAD` is required.  Omitting it will produce a
> `No available formula` or similar error.

The formula compiles `pgn` from source using the Haskell toolchain
(`ghc` + `cabal-install`) and links against Homebrew's `libpq`.  The first
install can take several minutes while Haskell dependencies are compiled.

### What gets installed

| Dependency | Role |
|---|---|
| `ghc` | Haskell compiler (build-time) |
| `cabal-install` | Haskell build tool (build-time) |
| `pkg-config` | Library discovery (build-time) |
| `libpq` | PostgreSQL client library (runtime) |

## Usage

```sh
pgn --help
```

Full documentation is available at [pgenie.io/docs](https://pgenie.io/docs/).

