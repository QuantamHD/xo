cc_library(
  name="fuse-example-lib",
  srcs=glob(["*.c"]),
  deps=["//third_party/fuse"]
)

cc_binary(
  name = "fuse-example",
  deps = [":fuse-example-lib"]
)
