class Ofa < Formula
  desc "One For All: detect and update every coding harness from a single CLI"
  homepage "https://github.com/KHAEntertainment/ofa"
  url "https://github.com/KHAEntertainment/ofa/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "3e86e22f2ae3cb6a252232e79053a187418631c1024a884cb02f97c4ac07bba5"
  license "MIT"

  depends_on "go" => :build

  def install
    # Build the ofa command from cmd/ofa. We don't strip with -s -w
    # because the binary is already small (~10 MB) and stripping
    # removes symbol info that's useful when triaging issues.
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/ofa"
  end

  test do
    # `ofa --version` exits 0 and prints the version string. The installed
    # binary must match the version baked into cmd/ofa/main.go.
    assert_match "ofa #{version}", shell_output("#{bin}/ofa --version")
  end
end
