class DevSkill < Formula
  desc "AI-assisted multi-agent development SOP for Claude Code"
  homepage "https://github.com/KHAEntertainment/claude-dev-skill"
  url "https://github.com/KHAEntertainment/claude-dev-skill/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "37ade32437390663e45d150f8a9f400e2edd7818bb869c37acb3a0ac691fb691"
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
