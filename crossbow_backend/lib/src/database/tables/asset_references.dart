import 'package:drift/drift.dart';

import '../mixins.dart';

/// The asset references table.
class AssetReferences extends Table with WithPrimaryKey, WithName {
  /// The folder that contains the asset with the given [name].
  TextColumn get folderName => text()();

  /// The gain to play this sound at.
  RealColumn get gain => real().withDefault(const Constant(0.7))();
}
