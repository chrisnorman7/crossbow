import 'package:drift/drift.dart';

import '../mixins.dart';
import 'asset_references.dart';
import 'call_commands.dart';

/// The menus table.
class Menus extends Table with WithPrimaryKey, WithName {
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

  /// The ID of a command to call when cancelling the menu.
  IntColumn get onCancelCallCommandId => integer()
      .references(CallCommands, #id, onDelete: KeyAction.setNull)
      .nullable()();
}
