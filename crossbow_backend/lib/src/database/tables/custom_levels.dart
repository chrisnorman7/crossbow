import 'package:drift/drift.dart';

import '../mixins.dart';
import 'asset_references.dart';

/// The custom levels table.
class CustomLevels extends Table with WithPrimaryKey, WithName {
  /// The ID of the music to play.
  IntColumn get musicId => integer()
      .references(AssetReferences, #id, onDelete: KeyAction.setNull)
      .nullable()();
}
