import strformat

# Package

version = "1.0.0"
author = "cobaltcore"
description = "A new awesome nimble package"
license = "MIT"
srcDir = "src"
bin = @["wopen", "wsave"]


# Dependencies

requires "nim >= 1.6.2"
requires "cligen >= 1.5.21"

# Tasks

task open, "Executes 'nimble run' with extra compiler options.":
  let args = join(commandLineParams[3..^1], " ")
  exec(&"nimble --gc:orc run open {args}")

task save, "Executes 'nimble run' with extra compiler options.":
  let args = join(commandLineParams[3..^1], " ")
  exec(&"nimble --gc:orc run save {args}")

task build_all_macos, "Executes 'nimble build' with extra compiler options.":
  exec("nimble build -d:release --opt:size --gc:orc --os:macosx -d:strip -y")
  exec("mkdir -p bin/macos && mv wopen bin/macos && mv wsave bin/macos")
  exec("upx --best bin/macos/*")

task build_all_windows, "Executes 'nimble build' with extra compiler options.":
  exec("nimble build -d:release --opt:size --gc:orc -d:mingw -d:strip -y")
  exec("mkdir -p bin/windows && mv wopen.exe bin/windows && mv wsave.exe bin/windows")
  exec("upx --best bin/windows/*")

task build_all_linux, "Executes 'nimble build' with extra compiler options.":
  exec("nimble build -d:release --opt:size --gc:orc --os:linux -d:strip -y")
  exec("mkdir -p bin/linux && mv wopen bin/linux && mv wsave bin/linux")
  exec("upx --best bin/linux/*")
