import 'package:drift/drift.dart';

import '../mixins.dart';
import 'commands.dart';

/// The call commands table.
class CallCommands extends Table with WithPrimaryKey, WithAfter {
  /// The ID of the command to call.
  IntColumn get commandId =>
      integer().references(Commands, #id, onDelete: KeyAction.cascade)();
}
