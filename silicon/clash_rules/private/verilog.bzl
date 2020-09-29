
load("//silicon/clash_rules:private/clash_utils.bzl", "get_transative_srcs")

def _clash_verilog_impl(ctx):
    trans_srcs = get_transative_srcs(ctx.files.srcs, ctx.attr.deps).to_list()
    clash_compiler = ctx.toolchains["//silicon/clash_rules:toolchain_type"]

    top_module = ctx.attr.top_level_module.split(".")

    if len(top_module) == 0:
      return fail(
        msg = "Top Level Module name cannot be blank"
      )

    top_module_string = top_module[0]

    verilog_output = ctx.actions.declare_file("verilog/{}/topEntity.v".format(top_module_string))

    (compiler_binaries, _) = ctx.resolve_tools(tools = [clash_compiler.compiler_target])


    ctx.actions.run_shell(
        tools = compiler_binaries,
        inputs = trans_srcs,
        outputs =  [verilog_output],
        command = "clash --verilog {} -iclash/ -fclash-hdldir {}".format(
          ctx.attr.top_level_module,
          verilog_output.dirname +"/../..",
        ),
        env = {
            "PATH": clash_compiler.clash_info.tools["ghc"].dirname
        }
    )


    return [
        DefaultInfo(files = depset([verilog_output]))
    ]


clash_verilog_impl = rule(
    implementation = _clash_verilog_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "deps": attr.label_list(allow_files = False),
        "top_level_module": attr.string(mandatory = True)
    },
    toolchains = ["//silicon/clash_rules:toolchain_type"],
)