load("//embedded/arduino_mkr:toolchain.bzl", "arduino_mkr_binary", "arduino_mkr_upload")

# The target to flash
arduino_mkr_binary(
    name = "main",
    srcs = ["main.c"],
)

arduino_mkr_upload(
    name = "test",
    raw_binary = ":main"
)