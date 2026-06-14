class Pgn < Formula
  desc "Type-safe PostgreSQL client code generator"
  homepage "https://pgenie.io"
  version "0.6.4"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/pgenie-io/pgenie/releases/download/v0.6.4/pgn-macos-arm64.tar.gz"
      sha256 "4848eb6853f5b034ed70d74c599f9ff78f99de8d4b736f8401d4f5850fb32056"
    end
    on_intel do
      url "https://github.com/pgenie-io/pgenie/releases/download/v0.6.4/pgn-macos-x64.tar.gz"
      sha256 "fa967ec57334a899260f3a8dd3117e61ebc07ca23432f36f65002ad61dfe95ad"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/pgenie-io/pgenie/releases/download/v0.6.4/pgn-linux-x64.tar.gz"
      sha256 "0d14571457d219ba0d44cb17b94eeafa738449cf28801367335a62186e53b990"
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
