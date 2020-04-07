load("@rules_cc//cc:defs.bzl", "cc_library")

package(
    default_visibility = ["//visibility:public"],
)

pcre_dir = "pcre-8.44/"

cc_library(
    name = "pcre",
    hdrs = [
        pcre_dir + "pcre.h",
    ],
    strip_include_prefix = pcre_dir,
    deps = [
        ":pcre-internal",
    ],
)

cc_library(
    name = "pcre-internal",
    srcs = glob([
        pcre_dir + "*.c",
        pcre_dir + "*.h",
    ]),
    copts = [
        "-DSUPPORT_UTF8",
        "-DSUPPORT_PCRE8",
        "-DLINK_SIZE=2",
        "-DPARENS_NEST_LIMIT=250",
        "-DMATCH_LIMIT=10000000",
        "-DMATCH_LIMIT_RECURSION=MATCH_LIMIT",
        "-DNEWLINE=10",
        "-DNO_RECURSE",
        "-DPOSIX_MALLOC_THRESHOLD=10",
        "-DMAX_NAME_SIZE=32",
        "-DMAX_NAME_COUNT=10000",
    ],
    linkstatic = 1,
    visibility = ["//visibility:private"],
)
