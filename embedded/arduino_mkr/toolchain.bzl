ArduinoMkrInfo = provider(
    doc = "Arduino ToolChain Info",
    fields = ["tools", "flash_tools", "flash_target"],
)

ArduinoMkrRawBinaryInfo = provider(
    fields = ["flash_binary"]
)

LINKER_SCRIPT = """
MEMORY
{
  FLASH (rx) : ORIGIN = 0x00000000+0x2000, LENGTH = 0x00040000-0x2000 /* First 8KB used by bootloader */
  RAM (rwx) : ORIGIN = 0x20000000, LENGTH = 0x00008000
}

ENTRY(Reset_Handler)

SECTIONS {
  .text : { 
    . = ALIGN(0x2000);
                KEEP(*(.isr_vector))
                *(.text*) 
  } > FLASH
  .data : { *(.data) } > FLASH 
}
"""

def _arduino_linker_script(ctx):
    out = ctx.actions.declare_file("___linker_script___.ld")
    ctx.actions.write(
        output = out,
        content = LINKER_SCRIPT,
    )
    return out

def _arduino_mkr_binary_impl(ctx):
    arm_compiler = ctx.toolchains["//embedded/arduino_mkr:toolchain_type"]

    (compiler_binaries, _) = ctx.resolve_tools(tools = [arm_compiler.compiler_target])

    output_executable_file = ctx.actions.declare_file(ctx.label.name + ".elf")
    linker_file = _arduino_linker_script(ctx)
    ctx.actions.run_shell(
        outputs = [output_executable_file],
        tools = compiler_binaries,
        inputs = ctx.files.srcs + [linker_file],
        command = "{} -mcpu=cortex-m0plus -mthumb -g -Os -w -std=gnu11 -ffunction-sections -fdata-sections -nostdlib -T{} {} -o {}".format(
            arm_compiler.arduino_mkr_info.tools["arm-none-eabi-gcc"].path,
            linker_file.path,
            " ".join([asm_file.path for asm_file in ctx.files.srcs]),
            output_executable_file.path,
        ),
    )

    output_raw_binary = ctx.actions.declare_file(ctx.label.name + ".bin")
    ctx.actions.run_shell(
        outputs = [output_raw_binary],
        tools = compiler_binaries,
        inputs = [output_executable_file],
        command = "{} -O binary {} {}".format(
            arm_compiler.arduino_mkr_info.tools["arm-none-eabi-objcopy"].path,
            output_executable_file.path,
            output_raw_binary.path
        )
    )

    return [DefaultInfo(files = depset([output_raw_binary])), ArduinoMkrRawBinaryInfo(flash_binary = output_raw_binary)]

arduino_mkr_binary = rule(
    implementation = _arduino_mkr_binary_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
    },
    toolchains = ["//embedded/arduino_mkr:toolchain_type"],
)

def _arduino_mkr_toolchain_impl(ctx):
    compiler_binaries = ctx.attr.compiler_package.files.to_list()
    compiler_dict = {file.basename: file for file in compiler_binaries}

    flash_binaries = ctx.attr.flash_package.files.to_list()
    flash_dict = {file.basename: file for file in flash_binaries}

    toolchain_info = platform_common.ToolchainInfo(
        arduino_mkr_info = ArduinoMkrInfo(
            tools = compiler_dict,
            flash_tools = flash_dict,
            flash_target = ctx.attr.flash_package
        ),
        compiler_target = ctx.attr.compiler_package,
    )
    return [toolchain_info]

arduino_mkr_toolchain = rule(
    implementation = _arduino_mkr_toolchain_impl,
    attrs = {
        "compiler_package": attr.label(),
        "flash_package": attr.label()
    },
)

def _arduino_mkr_upload(ctx):
    arm_compiler = ctx.toolchains["//embedded/arduino_mkr:toolchain_type"]

    out = ctx.actions.declare_file("upload.sh")

    ctx.actions.write(
        output = out,
        content = """
        #!/run/current-system/sw/bin/bash

        {} --port=ttyACM0 -i -e -w -v {} -R
        """.format(
            arm_compiler.arduino_mkr_info.flash_tools["bossac"].short_path,
            ctx.attr.raw_binary[ArduinoMkrRawBinaryInfo].flash_binary.short_path
        ),
    )

    runfiles = ctx.runfiles(files = [arm_compiler.arduino_mkr_info.flash_tools["bossac"], ctx.attr.raw_binary[ArduinoMkrRawBinaryInfo].flash_binary])
    return [DefaultInfo(executable = out, runfiles = runfiles)]


arduino_mkr_upload = rule(
    implementation = _arduino_mkr_upload,
    attrs = {
        "raw_binary": attr.label(providers = [ArduinoMkrRawBinaryInfo])
    },
    toolchains = ["//embedded/arduino_mkr:toolchain_type"],
    executable = True,
)