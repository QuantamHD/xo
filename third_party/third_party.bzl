load("//third_party/absl:absl.bzl", "absl")
load("//third_party/googletest:googletest.bzl", "googletest")
load("//third_party/clash:clash.bzl", "clash")
load("//third_party/nixpkgs_lilypond:nixpkgs_lilypond.bzl", "nixpkgs_lilypond")
load("//third_party/bazelbuild_com_github_rust_rules:bazelbuild_com_github_rust_rules.bzl", "bazelbuild_com_github_rust_rules", "bazelbuild_com_github_rust_rules_init")


def third_party():
  _load_deps()
  _init()

def _load_deps():
  """Only loading workspaces is allowed in these functions.
  """
  absl()
  googletest()
  clash()
  nixpkgs_lilypond()
  bazelbuild_com_github_rust_rules()

def _init():
  """Functions that require loading rules from workspace archives.

  This is useful for language rules that need to setup workspace rules like toolchains, etc.
  """
  bazelbuild_com_github_rust_rules_init()

