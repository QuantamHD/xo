load("@bazel_tools//tools/cpp:toolchain_utils.bzl", "find_cpp_toolchain")

def _change_extension(base_string, current_extension, new_extension):
    if not current_extension.startswith("."):
        current_extension = "." + current_extension

    if base_string.endswith(current_extension):
        return base_string[:-len(current_extension)] + new_extension

    return fail(
        msg = "base_string='{}' did not end with {}".format(
            base_string,
            current_extension,
        ),
    )

def _compile_prolog_files(ctx, prolog_toolchain, tool, srcs, extension):
    prolog_info = prolog_toolchain.prologinfo
    (prolog_compiler, _) = ctx.resolve_tools(tools = [prolog_toolchain.compiler_target])

    output_files = []
    for input_file in srcs:
        output_file = ctx.actions.declare_file(_change_extension(input_file.basename, input_file.extension, extension))
        ctx.actions.run_shell(
            outputs = [output_file],
            inputs = [input_file],
            tools = prolog_compiler,
            command = "{} -o {} {}".format(
                tool.path,
                output_file.path,
                input_file.path,
            ),
        )
        output_files.append(output_file)
    return output_files

def _compile_pl_to_wam(ctx, prolog_toolchain, srcs):
    return _compile_prolog_files(ctx, prolog_toolchain, prolog_toolchain.prologinfo.pl2wam, srcs, ".wam")

def _compile_wam_to_ma(ctx, prolog_toolchain, srcs):
    return _compile_prolog_files(ctx, prolog_toolchain, prolog_toolchain.prologinfo.wam2ma, srcs, ".ma")

def _compile_ma_to_asm(ctx, prolog_toolchain, srcs):
    return _compile_prolog_files(ctx, prolog_toolchain, prolog_toolchain.prologinfo.ma2asm, srcs, ".S")

def _prolog_binary_impl(ctx):
    prolog_toolchain = ctx.toolchains["//prolog_rules:toolchain_type"]

    wam_files = _compile_pl_to_wam(ctx, prolog_toolchain, ctx.files.srcs)
    ma_files = _compile_wam_to_ma(ctx, prolog_toolchain, wam_files)
    asm_files = _compile_ma_to_asm(ctx, prolog_toolchain, ma_files)

    cc_toolchain = find_cpp_toolchain(ctx)

    (prolog_shared_library, _) = ctx.resolve_tools(tools = [prolog_toolchain.shared_library])

    output_executable_file = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.run_shell(
        outputs = [output_executable_file],
        tools = prolog_shared_library,
        inputs = asm_files,
        command = "{} -o {} {} {} {}".format(
            cc_toolchain.compiler_executable,
            output_executable_file.path,
            " ".join([asm_file.path for asm_file in asm_files]),
            prolog_toolchain.link_path_arguments,
            " ".join(["-l:{}".format(library.basename) for library in prolog_toolchain.shared_library.files.to_list()]),
        ),
    )

    return [DefaultInfo(executable = output_executable_file)]

prolog_binary = rule(
    implementation = _prolog_binary_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = [".S", ".pl"]),
        "_cc_toolchain": attr.label(default = Label("@bazel_tools//tools/cpp:current_cc_toolchain")),
    },
    toolchains = ["//prolog_rules:toolchain_type", "@bazel_tools//tools/cpp:toolchain_type"],
    executable = True,
)

PrologInfo = provider(
    doc = "Information about how to invoke the prolog compiler.",
    fields = ["pl2wam", "wam2ma", "ma2asm"],
)

def _generate_link_path_arguments(shared_library_target):
    shared_library_link_paths = {library.dirname: True for library in shared_library_target.files.to_list()}
    return " ".join(["-L{}".format(link_path) for link_path in shared_library_link_paths.keys()])

def _prolog_toolchain_impl(ctx):
    compiler_binaries = ctx.attr.compiler_package.files.to_list()
    compiler_dict = {file.basename: file for file in compiler_binaries}

    toolchain_info = platform_common.ToolchainInfo(
        prologinfo = PrologInfo(
            pl2wam = compiler_dict["pl2wam"],
            wam2ma = compiler_dict["wam2ma"],
            ma2asm = compiler_dict["ma2asm"],
        ),
        compiler_target = ctx.attr.compiler_package,
        shared_library = ctx.attr.shared_library,
        link_path_arguments = _generate_link_path_arguments(ctx.attr.shared_library),
    )
    return [toolchain_info]

prolog_toolchain = rule(
    implementation = _prolog_toolchain_impl,
    attrs = {
        "compiler_package": attr.label(),
        "shared_library": attr.label(),
    },
)
