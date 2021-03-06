# diadog

> diadog, your loyal file dialog companion. Binaries to open native file dialogs on multiple platforms.

diadog is a collection of pre-built binaries for the most common desktop platforms which enables you to open native file dialogs easily and in a standardized manner, and receive the paths selected by the user back as a string.

This toolkit supports multiple forms of file dialogs, namely:
- Selecting a single file
- Selecting multiple files
- Selecting folders
- Selecting an output file

All file-related actions can optionally be supplied with a set of allowed file extensions to restrict the user input.

diadog supports the following platforms:
- Windows x64
- Windows x32
- Linux x64 (with GTK)
- Linux x32 (with GTK)
- macOS x64

Support for more platforms is planned, specifically:
- macOS arm64
- Linux x64 (no GTK)

This is based on work done by [nativefiledialog-extended](https://github.com/btzy/nativefiledialog-extended) and ships a slightly-modified version of its source to provide these binaries.

## Samples
```bash
$ dopen single
> "/Users/test/Documents/file.pdf"
```

```bash
$ dopen many
> "/Users/test/Documents/file1.pdf"
> "/Users/test/Documents/file2.pdf"
> "/Users/test/Documents/file3.pdf"
```

```bash
$ dsave single
> "/Users/test/Documents/out.txt"
```

## Usage

### `dopen`
```bash
Usage is like:
    dopen {SUBCMD} [subcommand-opts & args]
where subcommand syntaxes are as follows:

  single [optional-params]
    Select a single file.
  Options:
      -p=, --path=     string   ""  The path to open by default.
      --packages=      strings  {}  The display name of a set of file types to match.
      -f=, --filters=  strings  {}  The file types to match, in the order of the specified packages.

  many [optional-params]
    Select one or more files.
  Options:
      -p=, --path=     string   ""  The path to open by default.
      --packages=      strings  {}  The display name of a set of file types to match.
      -f=, --filters=  strings  {}  The file types to match, in the order of the specified packages.

  folder [optional-params]
    Select a folder.
  Options:
      -p=, --path=  string  ""  The path to open by default.
```

### `dsave`
```bash
Usage is like:
    dsave {SUBCMD} [subcommand-opts & args]
where subcommand syntaxes are as follows:

  single [optional-params]
    Save to a single file.
  Options:
      -n=, --name=     string   ""  The name to use by default.
      -p=, --path=     string   ""  The path to open by default.
      --packages=      strings  {}  The display name of a set of file types to match.
      -f=, --filters=  strings  {}  The file types to match, in the order of the specified packages.
```

### Notes
When supplying multiple filters, the first one will be used as the default file extension. For example, if you supply filters for two distinct packages for ZIP's and JPG's, in that order, the default file extension will be `.zip`.

### Example Invocations

#### `dopen`
##### Setting a custom start path
```bash
dopen single --path="/Users/test/Documents"
```

##### Setting valid file extensions
```bash
dopen single --pack="Image" --filter="jpg,jpeg"
```

##### Setting multiple valid file extensions
```bash
dopen single --pack="Image" --filter="jpg,jpeg" --pack="Archices" --filter="zip,tar,gz,rar"
```

#### `dsave`
##### Setting a custom start path
```bash
dsave single --path="/Users/test/Documents"
```

##### Setting valid file extensions
```bash
dsave single --pack="Image" --filter="jpg,jpeg"
```

##### Setting multiple valid file extensions
```bash
dsave single --pack="Image" --filter="jpg,jpeg" --pack="Archices" --filter="zip,tar,gz,rar"
```

#### Invoking from Python
```python
from subprocess import run

path = run(["./dopen", "single"], capture_output=True).stdout.decode().strip()
paths = run(["./dopen", "many"], capture_output=True).stdout.decode().split()
```

## Building
Building diadog

### Linux
Ensure that `libgtk-3-dev` is installed.
```bash
nimble build_linux_amd64
nimble build_linux_i386
```

### Windows
The recommended way is to cross-compile from Linux via MingW. No extra dependencies are required.
```bash
nimble build_windows_amd64
nimble build_windows_i386
```

### macOS
No extra dependencies are required.
```bash
nimble build_macos_amd64
```
