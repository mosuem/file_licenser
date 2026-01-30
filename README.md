A command-line application to add licenses to all dart files in a directory, if not already present*. Just run

```bash
dart run bin/file_licenser.dart ~/path/to/my/project/
```


*This is checked by searching for `// Copyright (c)` in the file, or checking for an existing health.yaml with a license and a license test string.
