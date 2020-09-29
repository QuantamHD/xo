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

    output_paths = [ctx.actions.declare_file(change_extension(file = file, new_extension = "o")) for file in ctx.files.srcs]
    output_path_parts = output_paths[0].dirname.split("/")

    if "clash" not in output_path_parts:
        return fail(
            msg= "All clash files must be in the clash root folder"
        )

    final_output_path_parts = []
    for path_part in output_path_parts:
        if path_part == "clash":
            final_output_path_parts.append(path_part)
            break
        final_output_path_parts.append(path_part)
    
    output_path_prefix = "/".join(final_output_path_parts)

    ctx.actions.run_shell(
        tools = compiler_binaries,
        inputs = trans_file_list,
        outputs =  output_paths,
        command = "clash --make -iclash/ -odir{output_dir} {file_paths}".format(
            file_paths = " ".join(file_paths),
            output_dir = output_path_prefix
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