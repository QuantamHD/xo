def _lilypond_pdf_impl(ctx):
  """
  LilyPond rules implementation.
  """

  output_pdf = ctx.actions.declare_file(ctx.attr.name + ".pdf")

  lilypond_binary = [file for file in ctx.files.lilypond_package if file.basename == "lilypond"][0]

  ctx.actions.run_shell(
    inputs = ctx.files.lilypond_support + ctx.files.srcs,
    outputs = [output_pdf],
    command = " {lilypond} -o {output} {inputs}".format(lilypond = lilypond_binary.path, output = output_pdf.path.replace(".pdf", ""), inputs = " ".join([file.path for file in ctx.files.srcs])),
    tools = ctx.files.lilypond_package,
  )
  return [DefaultInfo(files = depset([output_pdf]))]

lilypond_pdf = rule(
    implementation = _lilypond_pdf_impl,
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