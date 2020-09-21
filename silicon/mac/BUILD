load("//silicon/clash_rules:clash_rules.bzl", "clash_library", "clash_repl")

clash_library(
    name = "test",
    srcs = ["MAC.hs"],
    deps = [
        "//silicon/two"
    ]
)

clash_repl(
    name = "test_repl",
    deps = [
        ":test"
    ]
)