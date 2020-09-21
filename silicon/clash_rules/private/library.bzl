load("//util/bazel:file_utils.bzl", "change_extension")
load("//silicon/clash_rules:providers.bzl", "ClashLibraryInfo")
load("//silicon/clash_rules:private/clash_utils.bzl", "get_transative_srcs")


def _clash_library_impl(ctx):
    trans_srcs = get_transative_srcs(ctx.files.srcs, ctx.attr.deps)
    clash_compiler = ctx.toolchains["//silicon/clash_rules:toolchain_type"]

    (compiler_binaries, _) = ctx.resolve_tools(tools = [clash_compiler.compiler_target])

    trans_file_list = trans_srcs.to_list()
    file_paths = [file.path for file in trans_file_list]

    if len(ctx.files.srcs) == 0:
        return fail(
        msg = "No srcs were provided to generate output paths")

    output_haskell_directory = ctx.files.srcs[0].dirname

    output_paths = [ctx.actions.declare_file(change_extension(file = file, new_extension = "o")) for file in ctx.files.srcs]
    output_path = output_paths[0].dirname

    ctx.actions.run_shell(
        tools = compiler_binaries,
        inputs = trans_file_list,
        outputs =  output_paths,
        command = "{} {} && cp {}/*.o {}".format(
            clash_compiler.clash_info.tools["clash"].path,
            " ".join(file_paths),
            output_haskell_directory,
            output_path
        ),
        env = {
            "PATH": clash_compiler.clash_info.tools["ghc"].dirname
        }
    )

    return [
        DefaultInfo(files = depset(output_paths)),
        ClashLibraryInfo(transitive_srcs = trans_srcs)
    ]

clash_library_impl = rule(
    implementation = _clash_library_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "deps": attr.label_list(allow_files = False),
    },
    toolchains = ["//silicon/clash_rules:toolchain_type"],
)