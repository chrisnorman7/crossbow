import 'package:drift/drift.dart';

import 'asset_references.dart';
import 'menus.dart';
import 'mixins.dart';

/// The menu items table.
class MenuItems extends Table with WithPrimaryKey, WithName, WithVariableName {
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
}
