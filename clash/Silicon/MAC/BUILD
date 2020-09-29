load("//silicon/clash_rules:clash_rules.bzl", "clash_library", "clash_repl", "clash_verilog")

clash_library(
    name = "test",
    srcs = ["MAC.hs"],
    deps = [
        "//clash/Silicon/Two"
    ]
)

clash_repl(
    name = "test_repl",
    deps = [
        ":test"
    ]
)


clash_verilog(
    name = "verilog",
    deps = [
        ":test"
    ],
    top_level_module = "Silicon.MAC.MAC"
)