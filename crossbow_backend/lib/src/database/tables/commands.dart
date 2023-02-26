import 'package:drift/drift.dart';

import '../mixins.dart';
import 'asset_references.dart';
import 'pop_levels.dart';
import 'push_menus.dart';
import 'stop_games.dart';

/// The commands table.
class Commands extends Table with WithPrimaryKey {
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

  /// The ID of a stop game.
  IntColumn get stopGameId => integer()
      .references(StopGames, #id, onDelete: KeyAction.setNull)
      .nullable()();

  /// A URL to open.
  TextColumn get url => text().nullable()();

  /// The ID of a call command.
}
