// ignore_for_file: avoid_print
import 'dart:io';

import 'package:crossbow_backend/src/code_gen/project_code.dart';
import 'package:dart_style/dart_style.dart';

Future<void> main(final List<String> args) async {
  if (args.length != 2) {
    return print(
      'You must specify a project file to load and an output directory.',
    );
  }
  final stopWatch = Stopwatch()..start();
  final oldProjectFile = File(args.first);
  final newProjectDirectory = Directory(args.last);
  print(
    'Importing project ${oldProjectFile.path} into '
    '${newProjectDirectory.path}.',
  );
  if (!newProjectDirectory.existsSync()) {
    newProjectDirectory.createSync(recursive: true);
  }
  final projectCode = ProjectCode(
    formatter: DartFormatter(),
    oldProjectFile: oldProjectFile,
    outputDirectory: newProjectDirectory.path,
  );
  await projectCode.save();
  stopWatch.stop();
  print('Done in ${stopWatch.elapsed}.');
}
