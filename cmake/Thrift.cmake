# -*- cmake -*-

find_package(Thrift REQUIRED)

macro (thrift_compiler input_file GENERATED_FILES)
  #${THRIFT_PATH} --gen cpp:pure_enums --gen java
  message(INFO "Compiling thrift thingies")
endmacro(thrift_compiler input_file GENERATED_FILES)
