load("//third_party/absl:absl.bzl", "absl")
load("//third_party/googletest:googletest.bzl", "googletest")
load("//third_party/clash:clash.bzl", "clash")


def third_party():
  absl()
  googletest()
  clash()