load("clash_rules.bzl", "clash_toolchain", "clash_library")

toolchain_type(name = "toolchain_type")

toolchain(
    name = "clash_toolchain",
    exec_compatible_with = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
    target_compatible_with = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
    toolchain = ":clash_nix_toolchain",
    toolchain_type = ":toolchain_type",
)

clash_toolchain(
  name = "clash_nix_toolchain",
  compiler_package = "@clash//:bin",
)