class Ofa < Formula
  desc "One For All: detect and update every coding harness from a single CLI"
  homepage "https://github.com/KHAEntertainment/ofa"
  url "https://github.com/KHAEntertainment/ofa/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "05c9cdf90a6d99384cdf9802e9f90c2b353925ecaf8a56f979b93a2e19234a97"
  license "MIT"

  depends_on "go" => :build

  def install
    # Build the ofa command from cmd/ofa.
    #
    # The version is stamped at build time via -ldflags, matching what
    # the release workflow does. internal/cli holds the version in a
    # package-level var (not a const) precisely so -X can rewrite it —
    # an unstamped build reports "ofa dev".
    #
    # -s -w strips the symbol table and DWARF data, which takes the
    # binary from ~10 MB to ~7 MB.
    system "go", "build",
      *std_go_args(ldflags: "-s -w -X ofa/internal/cli.version=#{version}"),
      "./cmd/ofa"
  end

  test do
    # `ofa --version` exits 0 and prints the version string. The
    # installed binary must report the formula's version, which only
    # happens if the -X stamp above actually landed.
    assert_match "ofa #{version}", shell_output("#{bin}/ofa --version")
  end
end
