load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
http_archive(
    name = "rules_python",
    url = "https://github.com/bazelbuild/rules_python/releases/download/0.0.1/rules_python-0.0.1.tar.gz",
    sha256 = "aa96a691d3a8177f3215b14b0edc9641787abaaa30363a080165d06ab65e1161",
)
load("@rules_python//python:repositories.bzl", "py_repositories")
py_repositories()
# Only needed if using the packaging rules.
load("@rules_python//python:pip.bzl", "pip_repositories")
pip_repositories()


http_archive(
  name = "io_tweag_rules_nixpkgs",
  strip_prefix = "rules_nixpkgs-0.7.0",
  urls = ["https://github.com/tweag/rules_nixpkgs/archive/v0.7.0.tar.gz"],
  sha256 = "5c80f5ed7b399a857dd04aa81e66efcb012906b268ce607aaf491d8d71f456c8",
)

load("@io_tweag_rules_nixpkgs//nixpkgs:repositories.bzl", "rules_nixpkgs_dependencies")
rules_nixpkgs_dependencies()

load("@io_tweag_rules_nixpkgs//nixpkgs:nixpkgs.bzl", "nixpkgs_package", "nixpkgs_git_repository")

nixpkgs_git_repository(
    name = "nixpkgs",
    revision = "20.09", 
)

nixpkgs_package(
    name = "gprolog",
    repositories = {
        "nixpkgs": "@nixpkgs//:default.nix",
    }
)

nixpkgs_package(
    name = "gcc-arm-embedded",
    repositories = {
        "nixpkgs": "@nixpkgs//:default.nix",
    }
)

nixpkgs_package(
    name = "bossa",
    repositories = {
        "nixpkgs": "@nixpkgs//:default.nix",
    }
)
http_archive(
    name = "io_bazel_rules_rust",
    sha256 = "b5d4d1c7609714dfef821355f40353c58aa1afb3803401b3442ed2355db9b0c7",
    strip_prefix = "rules_rust-8d2b4eeeff9dce24f5cbb36018f2d60ecd676639",
    urls = [
        # Master branch as of 2020-11-10
        "https://github.com/bazelbuild/rules_rust/archive/8d2b4eeeff9dce24f5cbb36018f2d60ecd676639.tar.gz",
    ],
)

# Third Party
load("//third_party:third_party.bzl", "third_party")
third_party()
# Third Party





load("@io_bazel_rules_rust//rust:repositories.bzl", "rust_repositories")

rust_repositories()

register_toolchains("//prolog_rules:prolog_linux_toolchain")
register_toolchains("//embedded/arduino_mkr:arduino_mkr_toolchain")
register_toolchains("//silicon/clash_rules:clash_toolchain")