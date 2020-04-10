load("@rules_cc//cc:defs.bzl", "cc_library", "cc_binary")

cc_library(
  name="fuse-example-lib",
  srcs=glob(["*.c"]),
  deps=[
    "//third_party/fuse",
    "//third_party/libgit2",
  ]
)

cc_binary(
  name = "fuse-example",
  deps = [":fuse-example-lib"]
)
