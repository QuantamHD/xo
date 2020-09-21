
load("//silicon/clash_rules:private/clash_utils.bzl", "get_transative_srcs")

def _clash_repl_impl(ctx):
    trans_srcs = get_transative_srcs(ctx.files.srcs, ctx.attr.deps).to_list()
    clash_compiler = ctx.toolchains["//silicon/clash_rules:toolchain_type"]

    out = ctx.actions.declare_file("repl.sh")
    clash_tools = clash_compiler.clash_info.tools

    ctx.actions.write(
      output = out,
      content = """
      PATH=$(pwd)/{} clashi {}
      """.format(
        clash_tools["clashi"].dirname,
        " ".join([file.short_path for file in trans_srcs])
      )
    )

    runfiles = ctx.runfiles(files = list(clash_tools.values()) + trans_srcs)
    return [
        DefaultInfo(executable = out, runfiles = runfiles)
    ]


clash_repl_impl = rule(
    implementation = _clash_repl_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "deps": attr.label_list(allow_files = False),
    },
    toolchains = ["//silicon/clash_rules:toolchain_type"],
    executable = True,
)