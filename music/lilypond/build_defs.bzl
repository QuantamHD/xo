def _clash_toolchain_impl(ctx):
  """
  LilyPond rules implementation.
  """

    output_pdf = ctx.actions.declare_file(ctx.attr.name + ".pdf")

    lilypond_binary = [file for file in ctx.files.lilypond_package if file.basename == "lilypond"][0]

    ctx.actions.run_shell(
      inputs = ctx.files.lilypond_support + ctx.files.srcs,
      outputs = [o],
      command = " {lilypond} -o {output} {inputs}".format(
        lilypond = lilypond_binary.path,
        output = o.path.replace(".pdf", ""), 
        inputs = " ".join([file.path for file in ctx.files.srcs])
      ),
      tools = ctx.files.lilypond_package,
    )
    return [DefaultInfo(files = depset([o]))]

lilypond_pdf = rule(
    implementation = _clash_toolchain_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "lilypond_package": attr.label(
          default = "@lilypond//:bin",
        ),
        "lilypond_support": attr.label(
          default = "@lilypond//:share",
        )
    },
)