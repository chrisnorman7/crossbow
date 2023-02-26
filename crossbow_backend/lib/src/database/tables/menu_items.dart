import 'package:drift/drift.dart';

import '../mixins.dart';
import 'asset_references.dart';
import 'call_commands.dart';
import 'menus.dart';

/// The menu items table.
class MenuItems extends Table with WithPrimaryKey, WithName {
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

  /// The position of this item in the menu.
  IntColumn get position => integer().withDefault(const Constant(0))();

  /// The ID of a call command.
  IntColumn get callCommandId => integer()
      .references(CallCommands, #id, onDelete: KeyAction.setNull)
      .nullable()();
}
