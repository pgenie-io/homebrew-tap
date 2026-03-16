class Pgn < Formula
  desc "Type-safe PostgreSQL client code generator"
  homepage "https://pgenie.io"
  license "GPL-3.0-or-later"

  head "https://github.com/pgenie-io/pgenie.git", branch: "master"

  # Haskell toolchain (build-time only)
  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkg-config" => :build

  # PostgreSQL client library required by the postgresql-libpq C binding.
  # libpq is keg-only in Homebrew, so its prefix must be passed explicitly to
  # the cabal build below.
  depends_on "libpq"

  def install
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
  end

  test do
    system bin/"pgn", "--version"
  end
end
