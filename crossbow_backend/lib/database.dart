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

/// Add a [fadeTime] column.
mixin _WithFadeTime on Table {
  /// The fade time to use.
  RealColumn get fadeTime => real().nullable()();
}

/// Add a [after] column.
mixin _WithAfter on Table {
  /// How many milliseconds to wait before doing something.
  IntColumn get after => integer().nullable()();
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
      .references(CommandTriggerKeyboardKeys, #id, onDelete: KeyAction.setNull)
      .nullable()();
}

/// The menus table.
class Menus extends Table with _WithPrimaryKey, _WithName {
  /// The music to use for this menu.
  IntColumn get musicId => integer()
      .references(AssetReferences, #id, onDelete: KeyAction.setNull)
      .nullable()();

  /// The sound to use when selecting an item.
  IntColumn get selectItemSoundId => integer()
      .references(AssetReferences, #id, onDelete: KeyAction.setNull)
      .nullable()();

  /// The sound to use when selecting an item.
  IntColumn get activateItemSoundId => integer()
      .references(AssetReferences, #id, onDelete: KeyAction.setNull)
      .nullable()();
}

/// The menu items table.
class MenuItems extends Table with _WithPrimaryKey, _WithName {
  /// The menu this menu item belongs to.
  IntColumn get menuId =>
      integer().references(Menus, #id, onDelete: KeyAction.cascade)();

  /// The sound to use when this item is selected.
  IntColumn get selectSoundId => integer()
      .references(AssetReferences, #id, onDelete: KeyAction.setNull)
      .nullable()();

  /// The sound to use when this item is activated.
  IntColumn get activateSoundId => integer()
      .references(AssetReferences, #id, onDelete: KeyAction.setNull)
      .nullable()();
}

/// The pop levels table.
class PopLevels extends Table with _WithPrimaryKey, _WithFadeTime {}

/// The push menus table.
class PushMenus extends Table with _WithPrimaryKey, _WithAfter, _WithFadeTime {
  /// The ID of the menu to push.
  IntColumn get menuId =>
      integer().references(Menus, #id, onDelete: KeyAction.cascade)();
}

/// The call commands table.
class CallCommands extends Table with _WithPrimaryKey, _WithAfter {
  /// The ID of the command to call.
  IntColumn get commandId =>
      integer().references(Commands, #id, onDelete: KeyAction.cascade)();
}

/// The commands table.
class Commands extends Table with _WithPrimaryKey {
  /// The ID of a menu to push.
  IntColumn get pushMenuId => integer()
      .references(PushMenus, #id, onDelete: KeyAction.setNull)
      .nullable()();

  /// Some text to output.
  TextColumn get messageText => text().nullable()();

  /// The ID of a sound to play.
  IntColumn get messageSoundId => integer()
      .references(AssetReferences, #id, onDelete: KeyAction.setNull)
      .nullable()();

  /// How to pop a level.
  IntColumn get popLevelId => integer()
      .references(
        PopLevels,
        #id,
        onDelete: KeyAction.setNull,
      )
      .nullable()();

  /// The ID of another command to call.
  IntColumn get callCommandId => integer()
      .references(CallCommands, #id, onDelete: KeyAction.setNull)
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
    PopLevels,
    PushMenus,
    CallCommands,
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

  /// Dump all rows to the given [file].
  Future<void> dump(final File file) =>
      customStatement('vacuum into ?', [file.path]);
}
