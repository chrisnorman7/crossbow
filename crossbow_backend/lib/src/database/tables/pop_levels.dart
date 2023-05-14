import 'package:drift/drift.dart';

import 'mixins.dart';

/// The pop levels table.
class PopLevels extends Table
    with WithPrimaryKey, WithFadeLength, WithVariableName {
  /// The description for this pop level.
  TextColumn get description =>
      text().withDefault(const Constant('Pop a level.'))();
}
