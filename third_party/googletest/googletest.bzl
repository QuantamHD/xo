"""
The Googletest library for c++
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def googletest():
  http_archive(
      name = "com_google_googletest",
      urls = ["file:///xo/third_party/googletest/googletest-release-1.10.0.tar.gz"],
      sha256 = "9dc9157a9a1551ec7a7e43daea9a694a0bb5fb8bec81235d8a1e6ef64c716dcb",
      strip_prefix = "googletest-release-1.10.0",
  )