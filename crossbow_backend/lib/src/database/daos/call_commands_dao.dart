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

  /// Create a new call command to call the command with the given [command].
  Future<CallCommand> createCallCommand({
    required final Command command,
    final Command? callingCommand,
    final MenuItem? callingMenuItem,
    final Menu? onCancelMenu,
    final CustomLevelCommand? callingCustomLevelCommand,
    final CustomLevelCommand? releasingCustomLevelCommand,
    final int? after,
    final int? randomNumberBase,
  }) {
    if (callingCommand == null &&
        callingMenuItem == null &&
        onCancelMenu == null &&
        callingCustomLevelCommand == null &&
        releasingCustomLevelCommand == null) {
      throw StateError('This call command will be unattached.');
    }
    return into(callCommands).insertReturning(
      CallCommandsCompanion(
        commandId: Value(command.id),
        callingCommandId: Value(callingCommand?.id),
        callingMenuItemId: Value(callingMenuItem?.id),
        releasingCustomLevelCommandId: Value(releasingCustomLevelCommand?.id),
        onCancelMenuId: Value(onCancelMenu?.id),
        callingCustomLevelCommandId: Value(callingCustomLevelCommand?.id),
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

  /// Get an[update] query that matches [callCommand].
  UpdateStatement<$CallCommandsTable, CallCommand> getUpdateQuery(
    final CallCommand callCommand,
  ) =>
      update(callCommands)
        ..where((final table) => table.id.equals(callCommand.id));

  /// Set the [randomNumberBase] for [callCommand].
  Future<CallCommand> setRandomNumberBase({
    required final CallCommand callCommand,
    final int? randomNumberBase,
  }) async =>
      (await getUpdateQuery(callCommand).writeReturning(
        CallCommandsCompanion(
          randomNumberBase: Value(randomNumberBase),
        ),
      ))
          .single;

  /// Set the [after] value for [callCommand].
  Future<CallCommand> setAfter({
    required final CallCommand callCommand,
    final int? after,
  }) async =>
      (await getUpdateQuery(callCommand)
              .writeReturning(CallCommandsCompanion(after: Value(after))))
          .single;

  /// Set the [commandId] for [callCommand].
  Future<CallCommand> setCommandId({
    required final CallCommand callCommand,
    required final int commandId,
  }) async =>
      (await getUpdateQuery(callCommand).writeReturning(
        CallCommandsCompanion(commandId: Value(commandId)),
      ))
          .single;

  /// Delete [callCommand].
  Future<int> deleteCallCommand({
    required final CallCommand callCommand,
  }) =>
      (delete(callCommands)
            ..where((final table) => table.id.equals(callCommand.id)))
          .go();
}
