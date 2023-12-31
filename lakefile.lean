import Lake
open Lake DSL

package «lina» {}

lean_lib «Lina» {}

target ffi.o pkg : FilePath := do
  let oFile := pkg.buildDir / "native" / "ffi.o"
  let srcJob ← inputFile <| pkg.dir / "native" / "ffi.c"
  let picoHttp := pkg.dir / "native" / "picohttpparser/picohttpparser.c"
  let flags := #["-I", picoHttp.toString, "-I", (← getLeanIncludeDir).toString, "-fPIC"]
  buildO "ffi.cpp" oFile srcJob flags "clang"

extern_lib lina pkg := do
  let name := nameToStaticLib "lina"
  let ffiO ← fetch <| pkg.target ``ffi.o
  buildStaticLib (pkg.buildDir / "lib" / name) #[ffiO]