# Bazel IntelliJ Compatibility
Test compatibility between Bazel and IntelliJ plugin versions

To run the tests, run `run-local.sh`. It will download plugins and test against each specified Bazel version.
A directory called `results/` will be created containing the logs and a .csv file with the exit code for each test.
See `versions.sh` for the complete list. Assumes that building with the aspects is representative for a working plugin.

