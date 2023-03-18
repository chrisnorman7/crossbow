import 'package:drift/drift.dart';

import 'command_triggers.dart';
import 'custom_levels.dart';
import 'mixins.dart';

/// A table to link [CustomLevels] to [CommandTriggers].
class CustomLevelCommands extends Table with WithPrimaryKey, WithInterval {
  /// The ID of the custom level to attach to.
  IntColumn get customLevelId =>
      integer().references(CustomLevels, #id, onDelete: KeyAction.cascade)();

  /// The ID of the trigger to use.
  IntColumn get commandTriggerId =>
      integer().references(CommandTriggers, #id, onDelete: KeyAction.cascade)();
}
