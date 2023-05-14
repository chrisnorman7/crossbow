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
    PushCustomLevels,
    DartFunctions,
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
    CustomLevelCommandsDao,
    PushCustomLevelsDao,
    DartFunctionsDao,
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
  int get schemaVersion => 21;

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
            await m.addColumn(
              callCommands,
              callCommands.callingCustomLevelCommandId,
            );
          }
          if (from < 8) {
            await m.createTable(customLevels);
            await m.createTable(customLevelCommands);
            await m.createTable(pushCustomLevels);
            await m.addColumn(commands, commands.pushCustomLevelId);
          }
          if (from < 9) {
            await m.addColumn(
              customLevelCommands,
              customLevelCommands.interval,
            );
          }
          if (from < 10) {
            await m.addColumn(
              callCommands,
              callCommands.releasingCustomLevelCommandId,
            );
          }
          if (from < 11) {
            await m.createTable(dartFunctions);
            await m.addColumn(commands, commands.dartFunctionId);
          }
          if (from < 12) {
            await m.addColumn(assetReferences, assetReferences.detached);
          }
          if (from < 13) {
            await m.addColumn(dartFunctions, dartFunctions.functionName);
          }
          if (from < 14) {
            for (final column in [
              menus.upScanCode,
              menus.downScanCode,
              menus.upButton,
              menus.downButton,
              menus.activateAxis,
              menus.activateButton,
              menus.activateScanCode,
              menus.cancelAxis,
              menus.cancelButton,
              menus.cancelScanCode,
              menus.movementAxis,
            ]) {
              await m.addColumn(menus, column);
            }
          }
          if (from < 15) {
            await m.addColumn(assetReferences, assetReferences.comment);
          }
          if (from < 16) {
            await m.addColumn(menus, menus.variableName);
            await m.addColumn(menuItems, menuItems.variableName);
            await m.addColumn(commands, commands.variableName);
            await m.addColumn(pushCustomLevels, pushCustomLevels.variableName);
            await m.addColumn(pushMenus, pushMenus.variableName);
            await m.addColumn(stopGames, stopGames.variableName);
            await m.addColumn(assetReferences, assetReferences.variableName);
          }
          if (from < 17) {
            await m.addColumn(commandTriggers, commandTriggers.variableName);
          }
          if (from < 18) {
            await m.addColumn(commands, commands.description);
          }
          if (from < 19) {
            await m.addColumn(customLevels, customLevels.variableName);
          }
          if (from < 20) {
            await m.addColumn(popLevels, popLevels.description);
          }
          if (from < 21) {
            await m.addColumn(stopGames, stopGames.description);
          }
        },
      );
}
