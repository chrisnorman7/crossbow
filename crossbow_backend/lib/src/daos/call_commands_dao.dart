import 'package:drift/drift.dart';

import '../../database.dart';

part 'call_commands_dao.g.dart';

/// The DAO for call commands.
@DriftAccessor(tables: [CallCommands])
class CallCommandsDao extends DatabaseAccessor<CrossbowBackendDatabase>
    with _$CallCommandsDaoMixin {
  /// Create an instance.
  CallCommandsDao(super.db);

  /// Create a new call command to call the command with the given [commandId].
  Future<CallCommand> createCallCommand({
    required final int commandId,
    final int? after,
  }) =>
      into(callCommands).insertReturning(
        CallCommandsCompanion(
          commandId: Value(commandId),
          after: Value(after),
        ),
      );

  /// Get the call command with the given [id].
  Future<CallCommand> getCallCommand({required final int id}) {
    final query = select(callCommands)
      ..where((final table) => table.id.equals(id));
    return query.getSingle();
  }
}