"""
The Google absl library for c++
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def absl():
  http_archive(
      name = "com_google_absl",
      urls = ["file:///xo/third_party/absl/abseil-cpp-20200225.1.tar.gz"],
      sha256 = "0db0d26f43ba6806a8a3338da3e646bb581f0ca5359b3a201d8fb8e4752fd5f8",
      strip_prefix = "abseil-cpp-20200225.1",
  )