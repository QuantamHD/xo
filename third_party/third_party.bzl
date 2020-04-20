load("//third_party/absl:absl.bzl", "absl")
load("//third_party/googletest:googletest.bzl", "googletest")


def third_party():
  absl()
  googletest()