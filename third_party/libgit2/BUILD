load("@rules_cc//cc:defs.bzl", "cc_library")

package(
    default_visibility = ["//visibility:public"],
)

libgit2_dir = "libgit2-v1.0.0/"

hash_module = glob(
    include = [
        libgit2_dir + "src/hash/sha1.h",
        libgit2_dir + "src/hash/sha1/generic.c",
        libgit2_dir + "src/hash/sha1/generic.h",
        libgit2_dir + "src/hash/sha1/sha1dc/*.c",
        libgit2_dir + "src/hash/sha1/sha1dc/*.h",
    ],
    exclude = [
        libgit2_dir + "src/hash/sha1/win32.*",
        libgit2_dir + "src/hash/sha1/openssl.*",
        libgit2_dir + "src/hash/sha1/mbedtls.*",
        libgit2_dir + "src/hash/sha1/collisiondetect.*",
    ],
)

unix_module = glob([
    libgit2_dir + "src/unix/*.c",
    libgit2_dir + "src/unix/*.h",
])

allocators_module = glob([
    libgit2_dir + "src/allocators/*.c",
    libgit2_dir + "src/allocators/*.h",
])

xdiff_module = glob([
    libgit2_dir + "src/xdiff/*.c",
    libgit2_dir + "src/xdiff/*.h",
])

streams_module = glob([
    libgit2_dir + "src/streams/*.c",
    libgit2_dir + "src/streams/*.h",
])

transports_module = glob([
    libgit2_dir + "src/transports/*.c",
    libgit2_dir + "src/transports/*.h",
])

cc_library(
    name = "libgit2",
    hdrs = glob([
        libgit2_dir + "include/git2.h",
        libgit2_dir + "include/git2/*.h",
        libgit2_dir + "include/git2/sys/*.h",
    ]),
    strip_include_prefix = libgit2_dir,
    deps = [
        ":libgit2-internal",
    ],
)

cc_library(
    name = "libgit2-internal",
    srcs = glob([
               libgit2_dir + "src/*.c",
               libgit2_dir + "src/*.h",
               libgit2_dir + "include/*.h",
               libgit2_dir + "include/git2/*.h",
               libgit2_dir + "include/git2/sys/*.h",
           ]) + allocators_module +
           unix_module +
           hash_module +
           xdiff_module +
           streams_module +
           transports_module,
    includes = [
        libgit2_dir + "include",
        libgit2_dir + "src",
    ],
    linkstatic = 1,
    local_defines = [
        "LIBGIT2_NO_FEATURES_H",
        "THREADSAFE",
        "GIT_REGEX_BUILTIN",
    ],
    visibility = ["//visibility:private"],
    deps = [
        "//third_party/http-parser",
        "//third_party/pcre",
        "//third_party/zlib",
    ],
)
