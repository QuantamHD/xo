load("@rules_cc//cc:defs.bzl", "cc_library")

package(
    default_visibility = ["//visibility:public"],
)

fuse_directory = "fuse-3.9.1/"

cc_library(
    name = "fuse",
    hdrs = glob([fuse_directory + "include/*.h"]),
    strip_include_prefix = fuse_directory + "include",
    include_prefix = "third_party/fuse",
    deps = [":fuse_lib_internal"],
)

cc_library(
    name = "fuse_lib_internal",
    srcs = glob(
        [fuse_directory + "lib/*.c"],
        exclude = [fuse_directory + "lib/mount_bsd.c"],
    ) + [
        fuse_directory + "include/cuse_lowlevel.h",
        fuse_directory + "include/config.h",
        fuse_directory + "include/fuse_common.h",
        fuse_directory + "include/fuse_kernel.h",
        fuse_directory + "include/fuse_log.h",
        fuse_directory + "include/fuse_lowlevel.h",
        fuse_directory + "include/fuse_opt.h",
        fuse_directory + "include/fuse.h",
        fuse_directory + "lib/fuse_i.h",
        fuse_directory + "lib/mount_util.h",
        fuse_directory + "lib/fuse_misc.h",
    ] + [
        fuse_directory + "lib/modules/iconv.c",
        fuse_directory + "lib/modules/subdir.c",
    ],
    copts = [
        "-D_REENTRANT",
        "-D_LARGEFILE_SOURCE",
        "-DFUSERMOUNT_DIR=\\\"/run/wrappers/bin\\\"",
        "-Ithird_party/fuse/" + fuse_directory + "include",
    ],
    defines = [
        "_FILE_OFFSET_BITS=64",
        "FUSE_USE_VERSION=39",
    ],
    linkopts = [
        "-lrt",
        "-ldl",
        "-lpthread",
    ],
    linkstatic = 1,
    visibility = ["//visibility:private"],
)
