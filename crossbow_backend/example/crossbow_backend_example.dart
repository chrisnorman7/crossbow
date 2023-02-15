// ignore_for_file: avoid_print
import 'dart:io';

import 'package:crossbow_backend/crossbow_backend.dart';

Future<void> main() async {
  final projectContext =
      await ProjectContext.blank(projectFile: File('project.json'));
  await projectContext.run();
}
