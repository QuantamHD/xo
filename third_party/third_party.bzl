def register_bazel_dependencies(visibility=None):	
  native.local_repository(
    name = "abseil",
    path = "/xo/third_party/abseil/abseil-cpp-20200225.1",
  )

