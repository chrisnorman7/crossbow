import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dart_sdl/dart_sdl.dart';
import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:ziggurat/sound.dart';
import 'package:ziggurat/ziggurat.dart' hide Command;

import '../../crossbow_backend.dart';

/// The context for a particular project.
class ProjectContext {
  /// Create an instance.
  const ProjectContext({
    required this.file,
    required this.project,
    required this.db,
  });

  /// Create an instance from a file.
  factory ProjectContext.fromFile(final File file) {
    final data = file.readAsStringSync();
    final json = jsonDecode(data);
    final project = Project.fromJson(json);
    final databaseFile =
        File(path.join(file.parent.path, project.databaseFilename));
    final db = CrossbowBackendDatabase.fromFile(databaseFile);
    return ProjectContext(file: file, project: project, db: db);
  }

  /// Create and return a blank project.
  ///
  /// The created project will have only one command.
  static Future<ProjectContext> blank({
    required final File projectFile,
    final String databasePath = defaultDatabasePath,
  }) async {
    final databaseFile = File(path.join(projectFile.parent.path, databasePath));
    assert(
      !databaseFile.existsSync(),
      'Database file $databaseFile already exists.',
    );
    final db = CrossbowBackendDatabase.fromFile(databaseFile);
    final commands = db.commandsDao;
    final command = await commands.createCommand(
      messageText: 'This command has not been programmed.',
    );
    final project = Project(
      projectName: 'Untitled Project',
      initialCommandId: command.id,
      databaseFilename: databasePath,
    );
    return ProjectContext(file: projectFile, project: project, db: db)..save();
  }

  /// The file where the [project] is stored.
  final File file;

  /// The directory where [project] files are stored.
  Directory get projectDirectory => file.parent;

  /// The project this context references.
  final Project project;

  /// The directory where assets are stored.
  Directory get assetsDirectory =>
      Directory(path.join(projectDirectory.path, project.assetsDirectory));

  /// The database to use.
  final CrossbowBackendDatabase db;

  /// Get the initial command to run.
  Future<Command> get initialCommand =>
      db.commandsDao.getCommand(id: project.initialCommandId);

  /// Save the [project].
  void save() {
    final json = project.toJson();
    final data = indentedJsonEncoder.convert(json);
    file.writeAsStringSync(data);
  }

  /// Get a project runner for this project context.
  @useResult
  ProjectRunner get projectRunner {
    final sdl = Sdl()..init();
    final synthizer = Synthizer()..initialize();
    final synthizerContext = synthizer.createContext();
    final random = Random();
    return ProjectRunner(
      projectContext: this,
      sdl: sdl,
      synthizerContext: synthizerContext,
      random: random,
      soundBackend: SynthizerSoundBackend(
        context: synthizerContext,
        bufferCache: BufferCache(
          synthizer: synthizer,
          maxSize: 1.gb,
          random: random,
        ),
      ),
    );
  }

  /// Run this project.
  Future<void> run() => projectRunner.run();
}
