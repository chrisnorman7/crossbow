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
  Future<Command> createCommand({
    final int? callCommandId,
    final int? messageSoundId,
    final String? messageText,
    final int? popLevelId,
    final int? pushMenuId,
    final int? stopGameId,
  }) =>
      into(commands).insertReturning(
        CommandsCompanion(
          callCommandId: Value(callCommandId),
          messageSoundId: Value(messageSoundId),
          messageText: Value(messageText),
          popLevelId: Value(popLevelId),
          pushMenuId: Value(pushMenuId),
          stopGameId: Value(stopGameId),
        ),
      );

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

  /// Delete the command with the given [id].
  Future<int> deleteCommand({required final int id}) async {
    final query = delete(commands)..where((final table) => table.id.equals(id));
    return query.go();
  }

  /// Add message [text] to the command with the given [commandId].
  Future<Command> setMessageText({
    required final int commandId,
    final String? text,
  }) async {
    final query = update(commands)
      ..where((final table) => table.id.equals(commandId));
    return (await query
            .writeReturning(CommandsCompanion(messageText: Value(text))))
        .single;
  }

  /// Set the stop game for the command with the given [commandId].
  Future<Command> setStopGame({
    required final int commandId,
    required final int stopGameId,
  }) async {
    final query = update(commands)
      ..where((final table) => table.id.equals(commandId));
    return (await query
            .writeReturning(CommandsCompanion(stopGameId: Value(stopGameId))))
        .single;
  }

  /// Set the pop level for the command with the given [commandID].
  Future<Command> setPopLevel({
    required final int commandID,
    required final int popLevelId,
  }) async {
    final query = update(commands)
      ..where((final table) => table.id.equals(commandID));
    return (await query
            .writeReturning(CommandsCompanion(popLevelId: Value(popLevelId))))
        .single;
  }
}
