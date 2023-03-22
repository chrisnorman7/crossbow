import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dart_sdl/dart_sdl.dart';
import 'package:dart_sdl/init_flags.dart';
import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:ziggurat/sound.dart';
import 'package:ziggurat/util.dart';
import 'package:ziggurat/ziggurat.dart' as ziggurat;

import '../../constants.dart';
import '../../project_runner.dart';
import '../database/database.dart';
import '../json/project.dart';

/// The type for the dart functions map.
typedef DartFunctionsMap
    = Map<String, FutureOr<void> Function(ProjectRunner runner)>;

/// The context for a particular project.
class ProjectContext {
  /// Create an instance.
  const ProjectContext({
    required this.file,
    required this.project,
    required this.db,
    this.assetReferenceEncryptionKeys = const {},
    this.dartFunctionsMap = const {},
  });

  /// Create an instance from a file.
  factory ProjectContext.fromFile(
    final File file, {
    final String? encryptionKey,
    final Map<int, String> assetReferenceEncryptionKeys = const {},
    final DartFunctionsMap dartFunctionsMap = const {},
  }) {
    final String data;
    if (encryptionKey == null) {
      data = file.readAsStringSync();
    } else {
      data = decryptFileString(file: file, encryptionKey: encryptionKey);
    }
    final json = jsonDecode(data);
    final project = Project.fromJson(json);
    final databaseFile = File(
      path.join(file.parent.path, project.databaseFilename),
    );
    final db = CrossbowBackendDatabase.fromFile(databaseFile);
    return ProjectContext(
      file: file,
      project: project,
      db: db,
      assetReferenceEncryptionKeys: assetReferenceEncryptionKeys,
      dartFunctionsMap: dartFunctionsMap,
    );
  }

  /// Create and return a blank project.
  ///
  /// The created project will have only one command.
  static Future<ProjectContext> blank({
    required final File projectFile,
    final String databasePath = defaultDatabasePath,
    final String assetsPath = defaultAssetsPath,
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
      assetsDirectory: assetsPath,
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

  /// The file where the database is stored.
  File get dbFile =>
      File(path.join(projectDirectory.path, project.databaseFilename));

  /// The map of [AssetReference] `id`s to encryption keys for decrypting
  /// assets.
  final Map<int, String> assetReferenceEncryptionKeys;

  /// The custom dart functions to use.
  final DartFunctionsMap dartFunctionsMap;

  /// Get the initial command to run.
  Future<Command> get initialCommand =>
      db.commandsDao.getCommand(id: project.initialCommandId);

  /// Save the [project].
  void save() {
    final directory = assetsDirectory;
    if (!assetsDirectory.existsSync()) {
      directory.createSync(recursive: true);
    }
    final json = project.toJson();
    final data = indentedJsonEncoder.convert(json);
    file.writeAsStringSync(data);
  }

  /// Get a project runner for this project context.
  @useResult
  ProjectRunner get projectRunner {
    final sdl = Sdl()
      ..init(
        flags: const InitFlags(
          joystick: true,
          haptic: true,
          gameController: true,
          events: true,
        ).flags,
      );
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
