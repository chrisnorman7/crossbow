import 'package:drift/drift.dart';

import 'mixins.dart';

/// The stop game table.
class StopGames extends Table with WithPrimaryKey, WithAfter, WithVariableName {
  /// The description of this stop game.
  TextColumn get description =>
      text().withDefault(const Constant('Stop the game.'))();
}
