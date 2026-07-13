class Pgn < Formula
  desc "Type-safe PostgreSQL client code generator"
  homepage "https://pgenie.io"
  version "0.10.0"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/pgenie-io/pgenie/releases/download/v0.10.0/pgn-macos-arm64.tar.gz"
      sha256 "ab0e4479c3230371eec4fcfaa5ee258cc2dd1f1f72d88657d565c4e85936a53f"
    end
    on_intel do
      url "https://github.com/pgenie-io/pgenie/releases/download/v0.10.0/pgn-macos-x64.tar.gz"
      sha256 "4aa8d95ada451ce4fe7099c140d3a0072caf82dc8e5f790c75ec6bfa7857fd12"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/pgenie-io/pgenie/releases/download/v0.10.0/pgn-linux-x64.tar.gz"
      sha256 "fa62ff6c0fcbbbd45e434cc35820b4a3055e2883251cb3b6cb2bc23690eb3bb2"
    end
  end

  head "https://github.com/pgenie-io/pgenie.git", branch: "master"

  # Haskell toolchain — only needed when building from source (--HEAD).
  depends_on "cabal-install" => :build if build.head?
  depends_on "ghc" => :build if build.head?
  depends_on "pkg-config" => :build if build.head?

  # PostgreSQL client library required at runtime by the pre-built binaries and
  # by the postgresql-libpq C binding when building from source.
  depends_on "libpq"

  def install
    if build.head?
      libpq_prefix = Formula["libpq"].opt_prefix

      # cabal.project specifies `with-compiler: ghc-9.12.2` which expects an
      # executable named exactly `ghc-9.12.2`.  Override it here to use whatever
      # `ghc` Homebrew provides, and tell the postgresql-libpq binding where to
      # find the keg-only libpq headers and library.
      (buildpath/"cabal.project.local").write <<~EOS
        with-compiler: ghc

        package postgresql-libpq
          extra-include-dirs: #{libpq_prefix}/include
          extra-lib-dirs:     #{libpq_prefix}/lib
      EOS

      system "cabal", "v2-update"
      system "cabal", "v2-install", "pgenie:pgn",
             "--installdir=#{bin}",
             "--install-method=copy",
             "--overwrite-policy=always"
    else
      bin.install "pgn"
    end
  end

  test do
    system bin/"pgn", "--version"
  end
end
