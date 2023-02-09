import 'package:drift/drift.dart';

import '../../database.dart';

part 'commands_dao.g.dart';

/// The DAO for commands.
@DriftAccessor(tables: [Commands])
class CommandsDao extends DatabaseAccessor<CrossbowBackendDatabase>
    with _$CommandsDaoMixin {
  /// Create an instance.
  CommandsDao(super.db);

  /// Create a command.
  Future<Command> createCommand() =>
      into(commands).insertReturning(const CommandsCompanion());

  /// Get a command with the given [commandId].
  Future<Command> getCommand({required final int commandId}) {
    final query = select(commands)
      ..where((final table) => table.id.equals(commandId));
    return query.getSingle();
  }

  /// Clear a push menu instruction from a command with the given [commandId].
  Future<Command> clearPushMenu({required final int commandId}) async {
    // TODO(chrisnorman7): Don't retrieve the command if possible.
    final command = await getCommand(commandId: commandId);
    final pushMenuId = command.pushMenuId;
    if (pushMenuId != null) {
      final query = delete(pushMenus)
        ..where((final table) => table.id.equals(pushMenuId));
      await query.go();
    }
    return getCommand(commandId: commandId);
  }
}
