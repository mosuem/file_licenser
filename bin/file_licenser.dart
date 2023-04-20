import 'dart:io';

const license = '''
// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
''';
void main(List<String> arguments) {
  Directory dir = Directory(arguments.first);
  dir.list(recursive: true).forEach((f) {
    if (f.path.endsWith('.dart')) {
      var file = File(f.path);
      var readAsStringSync = file.readAsStringSync();
      if (!readAsStringSync.contains('// Copyright (c)')) {
        file.writeAsStringSync('$license\n$readAsStringSync');
      }
    }
  });
}
