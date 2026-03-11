# SPDX-FileCopyrightText: 2026 Siradel
# SPDX-License-Identifier: MIT

def _clang_format_toolchain_impl(ctx):
    return [platform_common.ToolchainInfo(_tool = ctx.executable.tool)]

clang_format_toolchain = rule(
    implementation = _clang_format_toolchain_impl,
    attrs = {
        "tool": attr.label(
            allow_files = True,
            mandatory = True,
            cfg = "exec",
            executable = True,
        ),
    },
    provides = [platform_common.ToolchainInfo],
)

def _declare_toolchain_impl(name, visibility, tool, os, cpu):
    clang_format_toolchain(
        name = name,
        tool = tool,
    )

    native.toolchain(
        name = name + "_toolchain",
        toolchain_type = "@clang_format_prebuilt//clang-format:toolchain_type",
        exec_compatible_with = [
            "@platforms//os:{}".format(os),
            "@platforms//cpu:{}".format(cpu),
        ],
        toolchain = ":" + name,
        visibility = visibility,
    )

declare_toolchain = macro(
    implementation = _declare_toolchain_impl,
    attrs = {
        "tool": attr.label(
            allow_files = True,
            mandatory = True,
            cfg = "exec",
            executable = True,
        ),
        "os": attr.string(
            mandatory = True,
            values = ["windows", "linux"],
            configurable = False,
        ),
        "cpu": attr.string(
            mandatory = True,
            configurable = False,
        ),
    },
)
