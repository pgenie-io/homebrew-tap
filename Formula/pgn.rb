class Pgn < Formula
  desc "Type-safe PostgreSQL client code generator"
  homepage "https://pgenie.io"
  version "0.1.0"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/pgenie-io/pgenie/releases/download/v0.1.0/pgn-macos-arm64.tar.gz"
      sha256 "dea9b579b251dd86a13ed51d125a6caccb566320a81598ce1c02c1f25772d7c0"
    end
    on_intel do
      url "https://github.com/pgenie-io/pgenie/releases/download/v0.1.0/pgn-macos-x86_64.tar.gz"
      sha256 "e4fe899ea3d8c95177cbf7e7cb8fbba390bffb2993c43a76230dd25d4b47dd49"
    end
  end

  head "https://github.com/pgenie-io/pgenie.git", branch: "master"

  # Haskell toolchain — only needed when building from source (--HEAD).
  depends_on "cabal-install" => :build if build.head?
  depends_on "ghc" => :build if build.head?
  depends_on "pkg-config" => :build if build.head?

  # PostgreSQL client library required by the postgresql-libpq C binding.
  # libpq is keg-only in Homebrew, so its prefix must be passed explicitly to
  # the cabal build below.  The pre-built binaries have libpq statically
  # linked, so this dependency is only needed for source builds.
  depends_on "libpq" if build.head?

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
      arch = Hardware::CPU.arm? ? "arm64" : "x86_64"
      bin.install "pgn-macos-#{arch}" => "pgn"
    end
  end

  test do
    system bin/"pgn", "--version"
  end
end
