load("@io_tweag_rules_nixpkgs//nixpkgs:nixpkgs.bzl", "nixpkgs_package")

_build_file_content = """
package(default_visibility = ["//visibility:public"])

filegroup(
    name = "bin",
    srcs = glob(["bin/*"], allow_empty = True),
)

filegroup(
    name = "share",
    srcs = glob(["share/lilypond/**"], allow_empty = True),
)
"""

def nixpkgs_lilypond(): 
  nixpkgs_package(
    name = "lilypond",
    repositories = {
        "nixpkgs": "@nixpkgs//:default.nix",
    },
    build_file_content = _build_file_content,
  )
