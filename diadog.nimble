import strformat

# Package

version = "1.3.0"
author = "cobaltcore"
description = "Cross-platform native file dialogs."
license = "MIT"
srcDir = "src"
bin = @["dopen", "dsave"]

# Dependencies

requires "nim >= 1.6.4"
requires "cligen >= 1.5.21"

# Tasks

task open, "Runs 'dopen' with extra arguments":
  let args = join(commandLineParams[3..^1], " ")
  exec(&"nimble --gc:orc run dopen {args}")

task save, "Runs 'dsave' with extr arguments":
  let args = join(commandLineParams[3..^1], " ")
  exec(&"nimble --gc:orc run dsave {args}")

task build_macos_amd64, "Builds for macOS (amd64)":
  exec("nimble build -d:release --opt:size --gc:orc --os:macosx -d:strip -y")
  exec("mkdir -p bin/amd64/macos && mv dopen bin/amd64/macos && mv dsave bin/amd64/macos")
  exec("upx --best bin/amd64/macos/*")

task build_linux_amd64, "Builds for linux (amd64)":
  exec("nimble build -d:diadogGTK -d:release --opt:size --gc:orc --os:linux --cpu:amd64 -d:strip -y")
  exec("mkdir -p bin/amd64/linux && mv dopen bin/amd64/linux && mv dsave bin/amd64/linux")
  exec("upx --best bin/amd64/linux/*")

task build_linux_i386, "Builds for linux (i386)":
  exec("nimble build -d:diadogGTK -d:release --opt:size --gc:orc --os:linux --cpu:i386 -d:strip -y")
  exec("mkdir -p bin/i386/linux && mv dopen bin/i386/linux && mv dsave bin/i386/linux")
  exec("upx --best bin/i386/linux/*")

task build_windows_amd64, "Builds for Windows (amd64)":
  exec("nimble build -d:release --opt:size --gc:orc -d:mingw --cpu:amd64 -d:strip -y")
  exec("mkdir -p bin/amd64/windows && mv dopen.exe bin/amd64/windows && mv dsave.exe bin/amd64/windows")
  exec("upx --best bin/amd64/windows/*")

task build_windows_i386, "Builds for Windows (i386)":
  exec("nimble build -d:release --opt:size --gc:orc -d:mingw --cpu:i386 -d:strip -y")
  exec("mkdir -p bin/i386/windows && mv dopen.exe bin/i386/windows && mv dsave.exe bin/i386/windows")
  exec("upx --best bin/i386/windows/*")
