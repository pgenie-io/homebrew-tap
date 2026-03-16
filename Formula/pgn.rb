# When cutting a new release of pgenie, update `version` and both `sha256`
# fields below.  The checksums can be obtained by running:
#
#   curl -sSL <url> | shasum -a 256
#
# or by checking the GitHub release page at:
#   https://github.com/pgenie-io/pgenie/releases
class Pgn < Formula
  desc "Type-safe PostgreSQL client code generator"
  homepage "https://pgenie.io"
  version "1.0.0"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/pgenie-io/pgenie/releases/download/v#{version}/pgn-macos-arm64.tar.gz"
      # sha256 must be updated for every new release
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end

    on_intel do
      url "https://github.com/pgenie-io/pgenie/releases/download/v#{version}/pgn-macos-x86_64.tar.gz"
      # sha256 must be updated for every new release
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  def install
    if Hardware::CPU.arm?
      bin.install "pgn-macos-arm64" => "pgn"
    else
      bin.install "pgn-macos-x86_64" => "pgn"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pgn --version")
  end
end
