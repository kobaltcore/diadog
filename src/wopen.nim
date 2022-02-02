import cligen
import sequtils
import strutils

import wrapper

proc single*(path = "", packages: seq[string] = @[], filters: seq[string] = @[]) =
  ## Select a single file.
  # Example:
  # open single --pack="Scenario_Archive" -f="zip" --pack="Image" -f="jpg,jpeg"
  if packages.len != filters.len:
    echo "Please specify a matching number of package names and filters."
    quit(1)
  var filter_list: seq[FilterItem]
  for (iname, ifilter) in zip(packages, filters):
    filter_list.add(FilterItem(name: iname.replace("_", " ").cstring, spec: ifilter.cstring))
  let item = open_file_single(default_path = path, filters = filter_list)
  if item != "":
    echo item

proc many*(path = "", packages: seq[string] = @[], filters: seq[string] = @[]) =
  ## Select one or more files.
  if packages.len != filters.len:
    echo "Please specify a matching number of package names and filters."
    quit(1)
  var filter_list: seq[FilterItem]
  for (iname, ifilter) in zip(packages, filters):
    filter_list.add(FilterItem(name: iname.replace("_", " ").cstring, spec: ifilter.cstring))
  for item in open_file_multiple(default_path = path, filters = filter_list):
    if item != "":
      echo item

proc folder*(path = "") =
  ## Select a folder.
  let item = open_folder(default_path = path)
  if item != "":
    echo item

when isMainModule:
  dispatchMulti(
    [single, help = {
      "path": "The path to open by default.",
      "packages": "The display name of a set of file types to match.",
      "filters": "The file types to match, in the order of the specified packages.",
    }],
    [many, help = {
      "path": "The path to open by default.",
      "packages": "The display name of a set of file types to match.",
      "filters": "The file types to match, in the order of the specified packages.",
    }],
    [folder, help = {
      "path": "The path to open by default.",
    }],
  )
