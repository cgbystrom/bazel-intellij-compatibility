#!/bin/bash
# Script to run compatibility checks between Bazel versions and IntelliJ plugin versions

if [[ ! -f /.dockerenv ]]; then
  echo "Not running inside Docker, aborting..."
  exit 1
fi;

RESULT_DIR="/results"
RESULT_CSV_FILE="$RESULT_DIR/results.csv"
PROJECT_DIR="/app"

set -o allexport
source ./versions.sh
set +o allexport

test () {
  cd ${PROJECT_DIR}
  rm -f ${RESULT_CSV_FILE}
  mkdir -p ${RESULT_DIR}
  for bazel_version in "${BAZEL_VERSIONS[@]}"
  do
    for plugin_version in "${!PLUGIN_VERSIONS[@]}"
    do
      plugin_dir="$PLUGIN_DIR/$plugin_version/ijwb/aspect"
      log_file="$RESULT_DIR/${bazel_version}_${plugin_version}.log"
      exit_code_file="$RESULT_DIR/${bazel_version}_${plugin_version}.exitCode"
      export USE_BAZEL_VERSION="$bazel_version"

      if [[ ! -f "$plugin_dir/intellij_info_bundled.bzl" ]]; then
        echo "Missing .bzl file in plugin aspect dir!"
        echo "Plugin dir ${plugin_dir}"
        echo "Bazel ${bazel_version} with plugin ${plugin_version}"
        exit 1
      fi

      if [[ -f "$exit_code_file" ]]; then
        echo "Already tested $bazel_version on plugin $plugin_version"
        echo "${bazel_version},${plugin_version},$(cat $exit_code_file)" >> ${RESULT_CSV_FILE}
        continue
      fi

      printf "Testing Bazel $bazel_version with plugin $plugin_version..."
      bazel build \
        --tool_tag=ijwb:IDEA:community \
        --keep_going \
        --verbose_failures \
        --curses=no \
        --color=no \
        --progress_in_terminal_title=no \
        --aspects=@intellij_aspect//:intellij_info_bundled.bzl%intellij_info_aspect \
        --override_repository=intellij_aspect=$plugin_dir \
        --output_groups=intellij-info-generic,intellij-info-java,intellij-resolve-java -- \
        //...:all &> ${log_file}
      exit_code=$?      
      echo "${bazel_version},${plugin_version},$exit_code" >> ${RESULT_CSV_FILE}
      echo ${exit_code} > ${exit_code_file}
      printf "exit code $exit_code\n"
    done
  done
}

test
zip -q -r /results/results.zip /results
