// ignore_for_file: avoid_print
import 'dart:io';

import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:dart_style/dart_style.dart';

Future<void> main(final List<String> args) async {
  final stopWatch = Stopwatch()..start();
  final File oldProjectFile;
  final Directory newProjectDirectory;
  if (args.length > 2) {
    print('Too many arguments.');
    print('At most, input_file and output_directory can be specified.');
    return;
  } else if (args.length > 1) {
    newProjectDirectory = Directory(args.last);
    oldProjectFile = File(args.first);
  } else if (args.length == 1) {
    oldProjectFile = File(args.first);
    final project = Project.fromFile(oldProjectFile);
    newProjectDirectory = Directory(project.appName);
  } else {
    oldProjectFile = File('project.json');
    final project = Project.fromFile(oldProjectFile);
    newProjectDirectory = Directory(project.appName);
  }
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
