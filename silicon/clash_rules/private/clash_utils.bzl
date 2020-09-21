load("//silicon/clash_rules:providers.bzl", "ClashLibraryInfo")

def get_transative_srcs(srcs, deps):
    return depset(
        srcs,
        transitive = [dep[ClashLibraryInfo].transitive_srcs for dep in deps]
    )


