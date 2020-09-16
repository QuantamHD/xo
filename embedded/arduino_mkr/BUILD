load("toolchain.bzl", "arduino_mkr_toolchain")

toolchain_type(name = "toolchain_type")

toolchain(
    name = "arduino_mkr_toolchain",
    exec_compatible_with = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
    target_compatible_with = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
    toolchain = ":arduino_mkr_linux",
    toolchain_type = ":toolchain_type",
)

arduino_mkr_toolchain(
  name = "arduino_mkr_linux",
  compiler_package = "@gcc-arm-embedded//:bin",
  flash_package = "@bossa//:bin",
)