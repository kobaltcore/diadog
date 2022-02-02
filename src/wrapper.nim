when defined(macosx):
  {.passL: "-framework AppKit", compile: "nfd-src/nfd_cocoa.m".}
elif defined(windows):
  {.passL: "-mwindows -lole32 -luuid", compile: "nfd-src/nfd_win.cpp".}
elif defined(linux):
  when defined(widowGTK):
    {.passC: staticExec("pkg-config --cflags gtk+-3.0"), passL: staticExec("pkg-config --libs gtk+-3.0"), compile: "nfd-src/nfd_gtk.cpp".}
  elif defined(widowPortal):
    {.passC: staticExec("pkg-config --cflags dbus-1"), passL: staticExec("pkg-config --libs dbus-1"), compile: "nfd-src/nfd_portal.cpp".}

{.push header: "nfd-src/nfd.h".}

type
  NFDResult = enum
    NFD_ERROR = 0
    NFD_OKAY = 1
    NFD_CANCEL = 2

  NFDPathSet {.importc: "nfdpathset_t".} = ptr object
  NFDPathSetEnum {.importc: "nfdpathsetenum_t".} = object
    `ptr`: pointer

  FilterItem* {.importc: "nfdnfilteritem_t".} = object
    name*: cstring
    spec*: cstring


proc NFD_Init() {.importc.}

proc NFD_Quit() {.importc.}

proc NFD_PathSet_GetEnum(
  pathSet: NFDPathSet,
  outEnumerator: var NFDPathSetEnum,
): NFDResult {.importc.}

proc NFD_PathSet_GetCount(
  pathSet: NFDPathSet,
  count: var cint,
): NFDResult {.importc.}

proc NFD_PathSet_EnumNext(
  enumerator: ptr NFDPathSetEnum,
  outPath: cStringArray,
): NFDResult {.importc.}

proc NFD_PathSet_FreeEnum(enumerator: var NFDPathSetEnum) {.importc.}

proc NFD_PathSet_Free(pathSet: NFDPathSet) {.importc.}

proc NFD_OpenDialogN(
  outPath: var cstring,
  filterList: ptr openArray[FilterItem] = nil,
  filterCount: cint = 0,
  defaultPath: cstring = "",
): NFDResult {.importc.}

proc NFD_OpenDialogMultipleN(
  outPaths: var NFDPathSet,
  filterList: ptr openArray[FilterItem] = nil,
  filterCount: cint = 0,
  defaultPath: cstring = "",
): NFDResult {.importc.}

proc NFD_SaveDialogN(
  outPath: var cstring,
  filterList: ptr openArray[FilterItem] = nil,
  filterCount: cint = 0,
  defaultPath: cstring = "",
  defaultName: cstring = "",
): NFDResult {.importc.}

proc NFD_PickFolderN(
  outPath: var cstring,
  defaultPath: cstring = "",
): NFDResult {.importc.}

{.pop.}

# Convenience Wrappers

proc open_file_single*(default_path = "", filters: openArray[FilterItem] = []): string =
  NFD_Init()
  var out_path: cstring
  let retval = NFD_OpenDialogN(out_path, filters.unsafeAddr, filters.len.cint, default_path)
  NFD_Quit()
  return $out_path

proc open_file_multiple*(default_path = "", filters: openArray[FilterItem] = []): seq[string] =
  NFD_Init()
  var out_paths: NFDPathSet
  discard NFD_OpenDialogMultipleN(out_paths, filters.unsafeAddr, filters.len.cint, default_path)

  var enumerator: NFDPathSetEnum
  discard NFD_PathSet_GetEnum(out_paths, enumerator)

  var count: cint
  discard NFD_PathSet_GetCount(out_paths, count)

  for i in 0..<count:
    var paths = newSeq[string](count)
    var cpaths = paths.toOpenArray(0, count - 1).allocCStringArray()
    discard NFD_PathSet_EnumNext(enumerator.unsafeAddr, cpaths)
    result.add(cpaths.cstringArrayToSeq()[0])

  NFD_PathSet_FreeEnum(enumerator)
  NFD_PathSet_Free(out_paths)

  NFD_Quit()

  return result

proc open_folder*(default_path = ""): string =
  NFD_Init()
  var out_path: cstring
  let retval = NFD_PickFolderN(out_path, default_path)
  NFD_Quit()
  return $out_path

proc save_file*(default_name = "", default_path = "", filters: openArray[FilterItem] = []): string =
  NFD_Init()
  var out_path: cstring
  let retval = NFD_SaveDialogN(out_path, filters.unsafeAddr, filters.len.cint, default_path, default_name)
  NFD_Quit()
  return $out_path
