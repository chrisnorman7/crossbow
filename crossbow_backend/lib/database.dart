import 'dart:io';

import 'package:dart_sdl/dart_sdl.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'src/daos/menus_dao.dart';

part 'database.g.dart';

/// Add an [id] primary key.
mixin _WithPrimaryKey on Table {
  /// The primary key.
  IntColumn get id => integer().autoIncrement()();
}

/// Add a [name] field.
mixin _WithName on Table {
  /// The name of this object.
  TextColumn get name => text()
      .withLength(max: 100)
      .withDefault(const Constant('Untitled Object'))();
}

/// The asset references table.
class AssetReferences extends Table with _WithPrimaryKey, _WithName {
  /// The folder that contains the asset with the given [name].
  TextColumn get folderName => text()();
}

/// The command keyboard triggers table.
class CommandTriggerKeyboardKeys extends Table with _WithPrimaryKey {
  /// The scan code to use.
  IntColumn get scanCode => intEnum<ScanCode>()();

  /// Whether or not the control key must be held.
  BoolColumn get control => boolean().withDefault(const Constant(false))();

  /// Whether or not the alt key must be held.
  BoolColumn get alt => boolean().withDefault(const Constant(false))();

  /// Whether or not the shift key must be held.
  BoolColumn get shift => boolean().withDefault(const Constant(false))();
}

/// The command triggers table.
class CommandTriggers extends Table with _WithPrimaryKey {
  /// The description of this command trigger.
  TextColumn get description => text().withLength(min: 3, max: 100).unique()();

  /// The game controller button that will trigger this command.
  IntColumn get gameControllerButton =>
      intEnum<GameControllerButton>().nullable()();

  /// The keyboard key to use.
  IntColumn get keyboardKeyId => integer()
      .references(CommandTriggerKeyboardKeys, #id, onDelete: KeyAction.cascade)
      .nullable()();
}

/// The menus table.
class Menus extends Table with _WithPrimaryKey, _WithName {
  /// The music to use for this menu.
  IntColumn get musicId => integer()
      .references(AssetReferences, #id, onDelete: KeyAction.cascade)
      .nullable()();

  /// The sound to use when selecting an item.
  IntColumn get selectItemSoundId => integer()
      .references(AssetReferences, #id, onDelete: KeyAction.cascade)
      .nullable()();

  /// The sound to use when selecting an item.
  IntColumn get activateItemSoundId => integer()
      .references(AssetReferences, #id, onDelete: KeyAction.cascade)
      .nullable()();
}

/// The menu items table.
class MenuItems extends Table with _WithPrimaryKey, _WithName {
  /// The menu this menu item belongs to.
  IntColumn get menuId =>
      integer().references(Menus, #id, onDelete: KeyAction.cascade)();

  /// The sound to use when this item is selected.
  IntColumn get selectSoundId => integer()
      .references(AssetReferences, #id, onDelete: KeyAction.cascade)
      .nullable()();

  /// The sound to use when this item is activated.
  IntColumn get activateSoundId => integer()
      .references(AssetReferences, #id, onDelete: KeyAction.cascade)
      .nullable()();
}

/// The commands table.
class Commands extends Table with _WithPrimaryKey {
  /// How many levels to pop.
  IntColumn get popLevels => integer().withDefault(const Constant(0))();

  /// The ID of a menu to push.
  IntColumn get menuId => integer()
      .references(Menus, #id, onDelete: KeyAction.setNull)
      .nullable()();

  /// Some text to output.
  TextColumn get messageText => text().nullable()();

  /// The ID of a sound to play.
  IntColumn get messageSoundId => integer()
      .references(AssetReferences, #id, onDelete: KeyAction.cascade)
      .nullable()();
}

/// The database to use.
@DriftDatabase(
  tables: [
    AssetReferences,
    CommandTriggers,
    CommandTriggerKeyboardKeys,
    Menus,
    MenuItems,
    Commands,
  ],
  daos: [
    MenusDao,
  ],
)
class CrossbowBackendDatabase extends _$CrossbowBackendDatabase {
  /// Create an instance.
  CrossbowBackendDatabase(
    final QueryExecutor? executor,
  ) : super(
          executor ?? NativeDatabase(File('db.sqlite3')),
        );

  /// The schema version.
  @override
  int get schemaVersion => 2;

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
            await m.createTable(commands);
          }
        },
      );

  /// Dump all rows to the given [file].
  Future<void> dump(final File file) =>
      customStatement('vacuum into ?', [file.path]);
}
