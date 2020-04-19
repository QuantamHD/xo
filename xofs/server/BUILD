load("@rules_cc//cc:defs.bzl", "cc_library", "cc_binary")

cc_library(
  name="libgit2-test-library",
  srcs=glob(["*.cc"]),
  deps=[
    "//third_party/libgit2",
    "@com_google_absl//absl/flags:flag",
    "@com_google_absl//absl/flags:parse"
  ]
)

cc_binary(
  name = "libgit2-test",
  deps = [":libgit2-test-library"]
)
