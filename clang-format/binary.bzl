# SPDX-FileCopyrightText: 2026 Siradel
# SPDX-License-Identifier: MIT

load("@platforms//host:constraints.bzl", "HOST_CONSTRAINTS")

TOOLCHAIN = "@clang_format_prebuilt//clang-format:toolchain_type"

def _clang_format_binary_impl(ctx):
    tool = ctx.toolchains[TOOLCHAIN]._tool

    extension = tool.extension
    if extension != "":
        extension = "." + extension

    file = ctx.actions.declare_file("clang-format" + extension)

    ctx.actions.symlink(
        output = file,
        target_file = tool,
        is_executable = True,
    )

    return [DefaultInfo(
        runfiles = ctx.runfiles(files = [tool]),
        executable = file,
    )]

clang_format_binary = rule(
    implementation = _clang_format_binary_impl,
    exec_compatible_with = HOST_CONSTRAINTS,
    executable = True,
    toolchains = [TOOLCHAIN],
)
