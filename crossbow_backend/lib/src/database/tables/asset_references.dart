import 'package:drift/drift.dart';

import 'mixins.dart';

/// The asset references table.
class AssetReferences extends Table
    with WithPrimaryKey, WithName, WithVariableName {
  /// The folder that contains the asset with the given [name].
  TextColumn get folderName => text()();

  /// The gain to play this sound at.
  RealColumn get gain => real().withDefault(const Constant(0.7))();

  /// Whether or not this asset reference is detached from any other row.
  BoolColumn get detached => boolean().withDefault(const Constant(false))();

  /// The comment string for this asset.
  ///
  /// Used by the `build-game` script.
  TextColumn get comment => text().nullable()();
}
