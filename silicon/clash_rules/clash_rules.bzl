load("//silicon/clash_rules:private/library.bzl", "clash_library_impl")
load("//silicon/clash_rules:private/repl.bzl", "clash_repl_impl")

ClashToolchainInfo = provider(
    doc = "Clash ToolChain Info",
    fields = ["tools"],
)

# The clash_library rule
clash_library = clash_library_impl

# The clash_repl rule
clash_repl = clash_repl_impl

def _clash_toolchain_impl(ctx):
    compiler_binaries = ctx.attr.compiler_package.files.to_list()
    compiler_dict = {file.basename: file for file in compiler_binaries}

    toolchain_info = platform_common.ToolchainInfo(
        clash_info = ClashToolchainInfo(
            tools = compiler_dict,
        ),
        compiler_target = ctx.attr.compiler_package,
    )
    return [toolchain_info]

clash_toolchain = rule(
    implementation = _clash_toolchain_impl,
    attrs = {
        "compiler_package": attr.label(),
    },
)