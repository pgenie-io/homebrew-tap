class Pgn < Formula
  desc "Type-safe PostgreSQL client code generator"
  homepage "https://pgenie.io"
  version "0.5.1"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/pgenie-io/pgenie/releases/download/v0.5.1/pgn-macos-arm64.tar.gz"
      sha256 "18c37549e9641db0035a7f68dd00777303e444f117a6a6a3162e29931b323c7c"
    end
    on_intel do
      url "https://github.com/pgenie-io/pgenie/releases/download/v0.5.1/pgn-macos-x64.tar.gz"
      sha256 "d7dffe8a8c2d179478cb444a91557e645e92e0e53f76ebdcf9b1740a011df732"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/pgenie-io/pgenie/releases/download/v0.5.1/pgn-linux-x64.tar.gz"
      sha256 "776beea12e3b7a63a762627e61a1d89e7d8ae6337f21e46ca489da3507fdf815"
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
