import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/call_commands.dart';

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
    final int? callingCommandId,
    final int? callingMenuItemId,
    final int? onCancelMenuId,
    final int? after,
    final int? randomNumberBase,
  }) {
    if (callingCommandId == null &&
        callingMenuItemId == null &&
        onCancelMenuId == null) {
      throw StateError('This call command will not be attached to any object.');
    }
    return into(callCommands).insertReturning(
      CallCommandsCompanion(
        commandId: Value(commandId),
        callingCommandId: Value(callingCommandId),
        callingMenuItemId: Value(callingMenuItemId),
        onCancelMenuId: Value(onCancelMenuId),
        after: Value(after),
        randomNumberBase: Value(randomNumberBase),
      ),
    );
  }

  /// Get the call command with the given [id].
  Future<CallCommand> getCallCommand({required final int id}) {
    final query = select(callCommands)
      ..where((final table) => table.id.equals(id));
    return query.getSingle();
  }

  /// Set the random number base for the call command with the given
  /// [callCommandId].
  Future<CallCommand> setRandomNumberBase({
    required final int callCommandId,
    final int? randomNumberBase,
  }) async {
    final query = update(callCommands)
      ..where((final table) => table.id.equals(callCommandId));
    return (await query.writeReturning(
      CallCommandsCompanion(
        randomNumberBase: Value(randomNumberBase),
      ),
    ))
        .single;
  }

  /// Set the [after] value for the call command with the given [callCommandId].
  Future<CallCommand> setAfter({
    required final int callCommandId,
    final int? after,
  }) async {
    final query = update(callCommands)
      ..where((final table) => table.id.equals(callCommandId));
    return (await query
            .writeReturning(CallCommandsCompanion(after: Value(after))))
        .single;
  }

  /// Set the [commandId] for the call command with the given [callCommandId].
  Future<CallCommand> setCommandId({
    required final int callCommandId,
    required final int commandId,
  }) async {
    final query = update(callCommands)
      ..where((final table) => table.id.equals(callCommandId));
    return (await query
            .writeReturning(CallCommandsCompanion(commandId: Value(commandId))))
        .single;
  }
}
