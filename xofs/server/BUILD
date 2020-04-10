load("@rules_cc//cc:defs.bzl", "cc_library", "cc_binary")

cc_library(
  name="libgit2-test-library",
  srcs=glob(["*.c"]),
  deps=["//third_party/libgit2"]
)

cc_binary(
  name = "libgit2-test",
  deps = [":libgit2-test-library"]
)
