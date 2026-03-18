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

## Creating a release

To create a release, trigger an action workflow with the version number as input.
The workflow will create a new release on GitHub and upload the prebuilt clang-format binary as an asset.

Go to the "Actions" tab, select the "Download and release prebuilt clang-format" workflow, and click on "Run workflow".
Enter the version number (e.g., `15.0.7`) and click on "Run workflow" to start the release process.

If the workflow fails during the release process, fix the issue and re-run it. If the release was created successfully, you can delete it from the "Releases" tab, as well as the associated tag, to clean up the repository. This can happen if files paths or URLs change.

If the test workflow fails but the release was successful, you can fix the failure on main and just create a new tag, for example `15.0.7-1`. The metadata associated with release `15.0.7` will be reused.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
