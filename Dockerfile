FROM ubuntu:18.04
RUN apt-get update
RUN apt-get install -y wget curl unzip pkg-config zip g++ zlib1g-dev unzip python3 openjdk-11-jdk
RUN wget -O /usr/local/bin/bazel https://github.com/bazelbuild/bazelisk/releases/download/v1.1.0/bazelisk-linux-amd64 && chmod +x /usr/local/bin/bazel
WORKDIR /app
ADD versions.sh /app
RUN /app/versions.sh download_plugins
ADD test.sh WORKSPACE BUILD MyLib.java MyBin.java /app/
ENTRYPOINT ["/app/test.sh"]
