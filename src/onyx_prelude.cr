require "intrinsics"
require "primitives"
require "reflect"
require "lib_c"
require "macros"
require "object"
require "reference"
require "exception"
require "value"
require "struct"
require "proc"
require "thread"

ifdef !gc_cc47
   require "gc"
   require "gc/boehm"
end

require "class"
require "comparable"
require "enumerable"
require "iterable"
require "iterator"
require "nil"
require "bool"
require "char"
require "number"
require "int"
require "float"
require "pointer"

require "onyx_type_primitives_layer"

ifdef gc_cc47
   require "ext/gc-cc47"
   require "gc"
end


require "slice"
require "range"
require "char/reader"
require "iconv"
require "string"
require "symbol"
require "enum"
require "static_array"
require "array"
require "hash"
require "set"
require "tuple"
require "named_tuple"
require "deque"
require "box"
require "math/math"
require "process"
require "io"
require "env"
require "file"
require "dir"
require "time"
require "random"
require "regex"
require "raise"
require "errno"
require "concurrent"
require "signal"
require "mutex"
require "kernel"
require "main"
require "ext"

require "onyx_object_additions"
require "onyx_set_additions"
require "onyx_regex_additions"
require "onyx_corner_stone_layer"

