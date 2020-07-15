load("prolog_rules.bzl", "prolog_binary", "prolog_toolchain")

toolchain_type(name = "toolchain_type")

toolchain(
    name = "prolog_linux_toolchain",
    exec_compatible_with = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
    target_compatible_with = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
    toolchain = ":prolog_linux",
    toolchain_type = ":toolchain_type",
)

prolog_toolchain(
  name = "prolog_linux",
  compiler_package = "@gprolog//:bin",
  shared_library = "@gprolog//:lib",
)

prolog_binary(
  name = "test",
  srcs = ["a.pl"],
)