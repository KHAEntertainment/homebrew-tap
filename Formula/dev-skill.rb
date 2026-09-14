class DevSkill < Formula
  desc "AI-assisted multi-agent development SOP for Claude Code"
  homepage "https://github.com/KHAEntertainment/claude-dev-skill"
  url "https://github.com/KHAEntertainment/claude-dev-skill/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "567d4f667bb7c68b0523bc36b65bd273c61e6118f6e157109c886d47b63cb738"
  license "MIT"

  depends_on "python@3.13"
  depends_on "rtk"

  def install
    # Install the entire skill tree to libexec, preserving exec bits
    libexec.install Dir["*"]
    # bin/dev-skill-install shim that execs the bundled installer
    (bin/"dev-skill-install").write <<~SH
      #!/bin/bash
      exec "#{libexec}/install.sh" "$@"
    SH
    (bin/"dev-skill-install").chmod 0755
  end

  test do
    # Dry-run install against a scratch config dir; assert detect_execution_backend.py is executable
    system "#{bin}/dev-skill-install", "--dry-run", "--config-dir", testpath
    assert_predicate libexec/"scripts/detect_execution_backend.py", :executable?
  end
end
