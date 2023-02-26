import 'dart:io';

import 'package:dart_sdl/dart_sdl.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'daos/_daos.dart';
import 'tables/_tables.dart';

part 'database.g.dart';

/// The database to use.
@DriftDatabase(
  tables: [
    AssetReferences,
    CommandTriggers,
    CommandTriggerKeyboardKeys,
    Menus,
    MenuItems,
    Commands,
    PopLevels,
    PushMenus,
    CallCommands,
    StopGames,
  ],
  daos: [
    MenusDao,
    MenuItemsDao,
    CommandsDao,
    PushMenusDao,
    CallCommandsDao,
    StopGamesDao,
    PopLevelsDao,
    AssetReferencesDao,
  ],
)
class CrossbowBackendDatabase extends _$CrossbowBackendDatabase {
  /// Create an instance.
  CrossbowBackendDatabase(
    final QueryExecutor? executor,
  ) : super(
          executor ?? NativeDatabase(File('db.sqlite3')),
        );

  /// Load an instance from the given [file].
  CrossbowBackendDatabase.fromFile(final File file)
      : super(NativeDatabase(file));

  /// The schema version.
  @override
  int get schemaVersion => 1;

  /// Migrate the database.
  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (final details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
        onCreate: (final m) async {
          await m.createAll();
        },
        onUpgrade: (final m, final from, final to) async {},
      );
}
