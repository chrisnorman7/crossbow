import 'dart:io';

import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:path/path.dart' as path;

/// Run a game in the current directory.
Future<void> main(final List<String> args) async {
  final File file;
  if (args.isNotEmpty) {
    file = File(args.first);
  } else {
    file = File(path.join(Directory.current.path, 'project.json'));
  }
  final projectContext = ProjectContext.fromFile(file, dartFunctionsMap: {});
  for (final dartFunction
      in await projectContext.db.dartFunctionsDao.getDartFunctions()) {
    projectContext.dartFunctionsMap[dartFunction.id] = (final projectRunner) =>
        projectRunner.game.outputText(dartFunction.description);
  }
  await projectContext.run();
}
