import cligen
import sequtils
import strutils

import wrapper

proc single*(name = "", path = "", packages: seq[string] = @[], filters: seq[string] = @[]) =
  ## Save to a single file.
  if packages.len != filters.len:
    echo "Please specify a matching number of package names and filters."
    quit(1)
  var filter_list: seq[FilterItem]
  for (iname, ifilter) in zip(packages, filters):
    filter_list.add(FilterItem(name: iname.replace("_", " ").cstring, spec: ifilter.cstring))
  let item = save_file(default_name = name, default_path = path, filters = filter_list)
  if item != "":
    echo item

when isMainModule:
  dispatchMulti(
    [single, help = {
      "name": "The name to use by default.",
      "path": "The path to open by default.",
      "packages": "The display name of a set of file types to match.",
      "filters": "The file types to match, in the order of the specified packages.",
    }],
  )
