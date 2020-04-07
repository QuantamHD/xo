load("@rules_cc//cc:defs.bzl", "cc_library")

package(
    default_visibility = ["//visibility:public"],
)

zlib_dir = "zlib-v1.2.11/"

cc_library(
    name = "zlib",
    hdrs = [
        zlib_dir + "zlib.h",
        zlib_dir + "zconf.h",
    ],
    strip_include_prefix = zlib_dir,
    deps = [
        ":zlib-internal",
    ],
)

cc_library(
    name = "zlib-internal",
    srcs = glob([
        zlib_dir + "*.c",
        zlib_dir + "*.h",
    ]),
    copts = [
        "-DHAVE_SYS_TYPES_H",
        "-DHAVE_STDINT_H",
        "-DHAVE_STDDEF_H",
        "-D_LARGEFILE64_SOURCE=1",
    ],
    linkstatic = 1,
    visibility = ["//visibility:private"],
)
