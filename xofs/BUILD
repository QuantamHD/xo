cc_library(
  name="fuse-example-lib",
  srcs=glob(["*.c"]) + ["@fuse//:include"],
  deps=[":fuse"]
)

cc_import(
  name="fuse",
  shared_library="@fuse//:lib/libfuse.so",
  hdrs=["@fuse//:include"]
)
