load("@rules_cc//cc:defs.bzl", "cc_library")

package(
    default_visibility = ["//visibility:public"],
)

http_parser_dir = "http-parser-v2.9.4/"

cc_library(
    name = "http-parser",
    hdrs = [
        http_parser_dir + "http_parser.h",
    ],
    strip_include_prefix = http_parser_dir,
    deps = [
        ":http-parser-internal",
    ],
)

cc_library(
    name = "http-parser-internal",
    srcs = [
        http_parser_dir + "http_parser.c",
        http_parser_dir + "http_parser.h",
    ],
    linkstatic = 1,
    visibility = ["//visibility:private"],
)
