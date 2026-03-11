# clang-format-prebuilt

This repository provides Bazel rules for fetching a prebuilt version of clang-format. It is intended to be used as a dependency in other Bazel projects that require clang-format for code formatting.

## Usage

Add `clang_format_prebuilt` as a dependency in your `MODULE.bazel` file:

```python
bazel_dep(name = "clang_format_prebuilt", version = "...")
```

> [!NOTE]
> This module is not currently published to the Bazel Central Registry, hence you might need to use an [`archive_override`](https://bazel.build/rules/lib/globals/module#archive_override) or a [`git_override`](https://bazel.build/rules/lib/globals/module#git_override) to reference it.

Then, you can run clang-format like this:

```
bazel run @clang_format_prebuilt//clang-format -- ARGS
```

Arguments referencing paths should be absolute, as Bazel executes the binary from a different working directory.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
