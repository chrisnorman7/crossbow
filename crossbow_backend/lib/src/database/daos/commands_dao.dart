import 'package:drift/drift.dart';
import 'package:meta/meta.dart';

import '../database.dart';
import '../tables/call_commands.dart';
import '../tables/commands.dart';
import '../tables/push_menus.dart';

part 'commands_dao.g.dart';

/// The DAO for commands.
@DriftAccessor(tables: [Commands, CallCommands, PushMenus])
class CommandsDao extends DatabaseAccessor<CrossbowBackendDatabase>
    with _$CommandsDaoMixin {
  /// Create an instance.
  CommandsDao(super.db);

  /// Create a command.
  Future<Command> createCommand({
    final int? messageSoundId,
    final String? messageText,
    final int? popLevelId,
    final int? pushMenuId,
    final int? stopGameId,
    final String? url,
  }) =>
      into(commands).insertReturning(
        CommandsCompanion(
          messageSoundId: Value(messageSoundId),
          messageText: Value(messageText),
          popLevelId: Value(popLevelId),
          pushMenuId: Value(pushMenuId),
          stopGameId: Value(stopGameId),
          url: Value(url),
        ),
      );

  /// Get a command with the given [id].
  Future<Command> getCommand({required final int id}) {
    final query = select(commands)..where((final table) => table.id.equals(id));
    return query.getSingle();
  }

  /// Set the push menu ID for the command with the given [commandId].
  Future<Command> setPushMenuId({
    required final int commandId,
    final int? pushMenuId,
  }) async {
    final query = update(commands)
      ..where((final table) => table.id.equals(commandId));
    return (await query
            .writeReturning(CommandsCompanion(pushMenuId: Value(pushMenuId))))
        .single;
  }

  /// Delete the command with the given [id].
  @internal
  Future<int> deleteCommand({required final int id}) async =>
      (delete(commands)..where((final table) => table.id.equals(id))).go();

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

  /// Set the ID of the sound to play for the command with the given
  /// [commandId].
  Future<Command> setMessageSoundId({
    required final int commandId,
    final int? assetReferenceId,
  }) async {
    final query = update(commands)
      ..where((final table) => table.id.equals(commandId));
    return (await query.writeReturning(
      CommandsCompanion(messageSoundId: Value(assetReferenceId)),
    ))
        .single;
  }

  /// Set the stop game for the command with the given [commandId].
  Future<Command> setStopGameId({
    required final int commandId,
    final int? stopGameId,
  }) async {
    final query = update(commands)
      ..where((final table) => table.id.equals(commandId));
    return (await query
            .writeReturning(CommandsCompanion(stopGameId: Value(stopGameId))))
        .single;
  }

  /// Set the pop level for the command with the given [commandID].
  Future<Command> setPopLevelId({
    required final int commandID,
    final int? popLevelId,
  }) async {
    final query = update(commands)
      ..where((final table) => table.id.equals(commandID));
    return (await query
            .writeReturning(CommandsCompanion(popLevelId: Value(popLevelId))))
        .single;
  }

  /// Set the URL of the command with the given [commandId] to the given [url].
  Future<Command> setUrl({
    required final int commandId,
    final String? url,
  }) async {
    final query = update(commands)
      ..where((final table) => table.id.equals(commandId));
    return (await query.writeReturning(CommandsCompanion(url: Value(url))))
        .single;
  }

  /// Get the commands to be called by the command with the given [commandId].
  Future<List<CallCommand>> getCallCommands({required final int commandId}) =>
      (select(callCommands)
            ..where((final table) => table.callingCommandId.equals(commandId)))
          .get();
}
