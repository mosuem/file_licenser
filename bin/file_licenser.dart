import 'dart:io';
import 'package:yaml/yaml.dart';

final defaultLicense = '''
// Copyright (c) ${DateTime.now().year}, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
''';

void main(List<String> arguments) {
  Directory dir =
      arguments.isEmpty ? Directory.current : Directory(arguments.first);

  String license = defaultLicense;
  String licenseTestString = '// Copyright (c)';

  var yamlFile = [
    File('${dir.path}/health.yaml'),
    File('${dir.path}/health.yml'),
  ].firstWhere((f) => f.existsSync(), orElse: () => File(''));

  if (yamlFile.path.isNotEmpty) {
    try {
      final doc = loadYaml(yamlFile.readAsStringSync());
      final foundLicense = _findRecursive(doc, 'license');
      final foundTestString = _findRecursive(doc, 'license_test_string');

      if (foundLicense != null) license = foundLicense.toString();
      if (foundTestString != null)
        licenseTestString = foundTestString.toString();
    } catch (e) {
      stderr.writeln('Warning: Failed to parse ${yamlFile.path}: $e');
    }
  }

  // CLI Override
  if (arguments.length > 1) {
    license = File(arguments[1]).readAsStringSync();
  }

  dir.list(recursive: true).forEach((f) {
    if (f is File && f.path.endsWith('.dart')) {
      final content = f.readAsStringSync();
      if (!content.contains(licenseTestString)) {
        print('Adding license to: ${f.path}');
        final newContent =
            license.endsWith('\n') ? '$license$content' : '$license\n$content';
        f.writeAsStringSync(newContent);
      }
    }
  });
}

dynamic _findRecursive(dynamic node, String key) {
  if (node is YamlMap) {
    if (node.containsKey(key)) return node[key];
    for (var value in node.values) {
      final found = _findRecursive(value, key);
      if (found != null) return found;
    }
  } else if (node is YamlList) {
    for (var item in node) {
      final found = _findRecursive(item, key);
      if (found != null) return found;
    }
  }
  return null;
}
