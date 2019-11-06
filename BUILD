# Empty build targets to give IntelliJ plugin something to analyze

java_library(
    name = "lib",
    srcs = ["MyLib.java"],
)

java_binary(
    name = "bin",
    srcs = ["MyBin.java"],
    deps = [":lib"],
    main_class = "MyBin"
)
