import 'package:drift/drift.dart';

import '../mixins.dart';
import 'commands.dart';

/// The pinned commands table.
class PinnedCommands extends Table with WithPrimaryKey, WithName {
  /// The ID of the command to pin.
  IntColumn get commandId =>
      integer().references(Commands, #id, onDelete: KeyAction.restrict)();
}
