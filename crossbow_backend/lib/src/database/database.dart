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
    PinnedCommands,
    CustomLevels,
    CustomLevelCommands,
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
    CommandTriggersDao,
    CommandTriggerKeyboardKeysDao,
    UtilsDao,
    PinnedCommandsDao,
    CustomLevelsDao,
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
  int get schemaVersion => 7;

  /// Migrate the database.
  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (final details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
        onCreate: (final m) async {
          await m.createAll();
        },
        onUpgrade: (final m, final from, final to) async {
          if (from < 2) {
            await m.alterTable(TableMigration(commands));
            await m.alterTable(TableMigration(menus));
            await m.alterTable(TableMigration(menuItems));
            for (final column in [
              callCommands.callingCommandId,
              callCommands.callingMenuItemId,
              callCommands.onCancelMenuId
            ]) {
              await m.addColumn(callCommands, column);
            }
          }
          if (from < 3) {
            await m.addColumn(callCommands, callCommands.randomNumberBase);
          }
          if (from < 5) {
            await m.alterTable(TableMigration(commandTriggers));
          }
          if (from < 6) {
            await m.createTable(pinnedCommands);
          }
          if (from < 7) {
            await m.createTable(customLevelCommands);
            await m.createTable(customLevels);
            await m.addColumn(callCommands, callCommands.customLevelCommandId);
          }
        },
      );
}
