#!/bin/bash
# Versions separately declared to benefit from Docker layer caching

PLUGIN_DIR="/plugins"

# From https://plugins.jetbrains.com/plugin/8609-bazel
# Extract PLUGIN_VERSIONS from developer console in browser:
# $$('.update-item__version-link').map(e => console.log("PLUGIN_VERSIONS[" + e.text + "]="+ e.href.split('/')[6])); 
declare -A PLUGIN_VERSIONS
PLUGIN_VERSIONS[2019.10.14.0.0]=71200
PLUGIN_VERSIONS[2019.10.21.0.0-6823f76]=70919
PLUGIN_VERSIONS[2019.10.18.0.0]=70820
PLUGIN_VERSIONS[2019.10.01.1.1]=70431
PLUGIN_VERSIONS[2019.09.03.0.0]=69553
PLUGIN_VERSIONS[2019.08.19.0.6]=68726
PLUGIN_VERSIONS[2019.08.19.0.5]=68015
PLUGIN_VERSIONS[2019.08.05.0.0]=67440
PLUGIN_VERSIONS[2019.07.23.0.3]=66646
PLUGIN_VERSIONS[2019.07.08.0.2]=65796
PLUGIN_VERSIONS[2019.06.17.0.1]=64790
PLUGIN_VERSIONS[2019.06.03.0.1]=64388
PLUGIN_VERSIONS[2019.05.13.0.2]=62928
PLUGIN_VERSIONS[2019.05.01.0.3]=62168
PLUGIN_VERSIONS[2019.04.15.0.5]=61486
PLUGIN_VERSIONS[2019.04.02.0.4]=60935
PLUGIN_VERSIONS[2019.03.18.0.2]=60336
PLUGIN_VERSIONS[2019.03.05.0.1]=59525
PLUGIN_VERSIONS[2019.02.13.0.3]=58936
PLUGIN_VERSIONS[2019.01.28.0.2]=57995
PLUGIN_VERSIONS[2019.01.14.0.5]=54558
PLUGIN_VERSIONS[2019.01.02.0.2]=54054
PLUGIN_VERSIONS[2018.12.03.0.2]=53279
PLUGIN_VERSIONS[2018.11.12.0.4]=52597
PLUGIN_VERSIONS[2018.10.22.0.2]=51711
PLUGIN_VERSIONS[2018.10.08.0.2]=51284
PLUGIN_VERSIONS[2018.10.01.0.1]=50771
PLUGIN_VERSIONS[2018.08.20.0.3]=49511
PLUGIN_VERSIONS[2018.08.06.0.1]=48989
PLUGIN_VERSIONS[2018.07.23.0.5]=48579
PLUGIN_VERSIONS[2018.07.09.0.1]=47936
PLUGIN_VERSIONS[2018.06.11.0.3]=47324
PLUGIN_VERSIONS[2018.05.21.0.0]=46515
PLUGIN_VERSIONS[2018.05.07.0.2]=46049
PLUGIN_VERSIONS[2018.04.23.0.3]=45624
PLUGIN_VERSIONS[2018.04.09.0.2]=45218
PLUGIN_VERSIONS[2018.03.26.0.5]=44838
PLUGIN_VERSIONS[2018.03.12.0.6]=44452
PLUGIN_VERSIONS[2018.02.26.0.3]=44076
PLUGIN_VERSIONS[2018.01.29.0.2]=43660
#PLUGIN_VERSIONS[2018.01.29.0.0]=42692 # Does not exist?

# Use most recent stable version of each minor release
BAZEL_VERSIONS=(
  1.1.0
  0.29.1
  0.28.0
  0.27.2
  0.26.1
  0.25.3
  0.24.1
  0.23.2
  0.22.0
  0.21.0
  0.20.0
  0.19.2
  0.18.1
  0.17.2
  0.16.1
  0.15.2
  0.14.1
  0.13.1
  0.12.0
  0.11.1
  0.10.1

  # Currently skipping these to save time since they are old. Are people still using them?
  #0.9.0
  #0.8.1
  #0.7.0
  #0.6.1
  #0.5.4
  #0.4.5
  #0.3.2
  #0.2.3
  #0.1.5
)

download_plugins () {
  mkdir -p ${PLUGIN_DIR}
  cd ${PLUGIN_DIR}

  for version in "${!PLUGIN_VERSIONS[@]}"
  do
    filename="$version.zip"
    id="${PLUGIN_VERSIONS[$version]}"
    url="https://plugins.jetbrains.com/files/8609/$id/ijwb_bazel.zip"
    if [[ ! -f "$filename" ]]; then
      wget -O ${filename}  ${url}
      mkdir -p ${version}
      unzip -d ${version} ${filename}
    fi
  done
  cd $PWD
}

if [[ "$1" == "download_plugins" ]]; then
  download_plugins
  exit 0
fi