import 'package:drift/drift.dart';

import 'custom_levels.dart';
import 'mixins.dart';

/// The push custom levels table.
class PushCustomLevels extends Table
    with WithPrimaryKey, WithAfter, WithFadeLength, WithVariableName {
  /// The ID of the custom level to push.
  IntColumn get customLevelId =>
      integer().references(CustomLevels, #id, onDelete: KeyAction.cascade)();
}
