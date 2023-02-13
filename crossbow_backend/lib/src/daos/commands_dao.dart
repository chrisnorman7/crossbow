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

  /// Get a command with the given [id].
  Future<Command> getCommand({required final int id}) {
    final query = select(commands)..where((final table) => table.id.equals(id));
    return query.getSingle();
  }

  /// Set the push menu ID for the command with the given [commandId].
  Future<Command> setPushMenu({
    required final int commandId,
    required final int pushMenuId,
  }) async {
    final query = update(commands)
      ..where((final table) => table.id.equals(commandId));
    return (await query
            .writeReturning(CommandsCompanion(pushMenuId: Value(pushMenuId))))
        .single;
  }
}
