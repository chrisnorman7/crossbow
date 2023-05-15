import 'dart:io';

import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:dart_style/dart_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

/// Build the project whose `project.json` resides at [filename].
Future<void> buildProjectFromFilename(final String filename) async {
  final formatter = DartFormatter();
  final file = File(filename);
  final project = Project.fromFile(file);
  final projectCode = ProjectCode(
    formatter: formatter,
    oldProjectFile: file,
    outputDirectory: path.join(
      file.parent.path,
      project.appName,
    ),
  );
  await projectCode.save();
}

/// The key that will hold the app preferences.
const appPreferencesKey = 'crossbow_preferences';

/// The icon shown when creating something.
final intlNewIcon = Icon(
  Icons.new_label,
  semanticLabel: Intl.message('New'),
);

/// How much `after` values should be changed by.
const afterModifier = 100;

/// The regular expression to use for variable names.
final variableNameRegExp = RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$');
