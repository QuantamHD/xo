load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@io_bazel_rules_rust//rust:repositories.bzl", "rust_repositories")

def bazelbuild_com_github_rust_rules():
  http_archive(
      name = "io_bazel_rules_rust",
      sha256 = "b5d4d1c7609714dfef821355f40353c58aa1afb3803401b3442ed2355db9b0c7",
      strip_prefix = "rules_rust-8d2b4eeeff9dce24f5cbb36018f2d60ecd676639",
      urls = [
          # Master branch as of 2020-11-10
          "https://github.com/bazelbuild/rules_rust/archive/8d2b4eeeff9dce24f5cbb36018f2d60ecd676639.tar.gz",
      ],
  )

def bazelbuild_com_github_rust_rules_init():
  rust_repositories()