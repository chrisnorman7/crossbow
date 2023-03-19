import 'package:drift/drift.dart';
import 'package:meta/meta.dart';

import '../database.dart';
import '../tables/call_commands.dart';
import '../tables/commands.dart';
import '../tables/pinned_commands.dart';
import '../tables/push_menus.dart';

part 'commands_dao.g.dart';

/// The DAO for commands.
@DriftAccessor(tables: [Commands, CallCommands, PushMenus, PinnedCommands])
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
    final int? pushCustomLevelId,
    final int? dartFunctionId,
  }) =>
      into(commands).insertReturning(
        CommandsCompanion(
          messageSoundId: Value(messageSoundId),
          messageText: Value(messageText),
          popLevelId: Value(popLevelId),
          pushMenuId: Value(pushMenuId),
          stopGameId: Value(stopGameId),
          url: Value(url),
          pushCustomLevelId: Value(pushCustomLevelId),
          dartFunctionId: Value(dartFunctionId),
        ),
      );

  /// Get a command with the given [id].
  Future<Command> getCommand({required final int id}) {
    final query = select(commands)..where((final table) => table.id.equals(id));
    return query.getSingle();
  }

  /// Get an [update] query which matches on [id].
  UpdateStatement<$CommandsTable, Command> getUpdateQuery(final int id) =>
      update(commands)..where((final table) => table.id.equals(id));

  /// Set the push menu ID for the command with the given [commandId].
  Future<Command> setPushMenuId({
    required final int commandId,
    final int? pushMenuId,
  }) async =>
      (await getUpdateQuery(commandId)
              .writeReturning(CommandsCompanion(pushMenuId: Value(pushMenuId))))
          .single;

  /// Delete the command with the given [id].
  @internal
  Future<int> deleteCommand({required final int id}) async =>
      (delete(commands)..where((final table) => table.id.equals(id))).go();

  /// Add message [text] to the command with the given [commandId].
  Future<Command> setMessageText({
    required final int commandId,
    final String? text,
  }) async =>
      (await getUpdateQuery(commandId)
              .writeReturning(CommandsCompanion(messageText: Value(text))))
          .single;

  /// Set the [assetReferenceId] of the command with the given [commandId].
  Future<Command> setMessageSoundId({
    required final int commandId,
    final int? assetReferenceId,
  }) async =>
      (await getUpdateQuery(commandId).writeReturning(
        CommandsCompanion(messageSoundId: Value(assetReferenceId)),
      ))
          .single;

  /// Set the [stopGameId] for the command with the given [commandId].
  Future<Command> setStopGameId({
    required final int commandId,
    final int? stopGameId,
  }) async =>
      (await getUpdateQuery(commandId)
              .writeReturning(CommandsCompanion(stopGameId: Value(stopGameId))))
          .single;

  /// Set the [popLevelId] for the command with the given [commandId].
  Future<Command> setPopLevelId({
    required final int commandId,
    final int? popLevelId,
  }) async =>
      (await getUpdateQuery(commandId)
              .writeReturning(CommandsCompanion(popLevelId: Value(popLevelId))))
          .single;

  /// Set the [url] for the command with the given [commandId].
  Future<Command> setUrl({
    required final int commandId,
    final String? url,
  }) async =>
      (await getUpdateQuery(commandId)
              .writeReturning(CommandsCompanion(url: Value(url))))
          .single;

  /// Get the call commands to be called by the command with the given
  /// [commandId].
  Future<List<CallCommand>> getCallCommands({required final int commandId}) =>
      (select(callCommands)
            ..where((final table) => table.callingCommandId.equals(commandId)))
          .get();

  /// Get the call commands which call the command with the given [commandId].
  Future<List<CallCommand>> getCallingCallCommands({
    required final int commandId,
  }) =>
      (select(callCommands)
            ..where((final table) => table.commandId.equals(commandId)))
          .get();

  /// Get a pinned command which represents the command with the given
  /// [commandId].
  Future<PinnedCommand?> getPinnedCommand({
    required final int commandId,
  }) =>
      (select(pinnedCommands)
            ..where((final table) => table.commandId.equals(commandId)))
          .getSingleOrNull();

  /// Returns `true` if the command with the given [commandId] has an associated
  /// [PinnedCommand] row.
  Future<bool> isPinned({required final int commandId}) async {
    final countColumn = countAll(
      filter: pinnedCommands.commandId.equals(commandId),
    );
    final query = select(pinnedCommands).addColumns([countColumn]);
    final row = await query.getSingle();
    final result = row.read(countColumn);
    return result != null && result > 0;
  }

  /// Returns `true` if this command is called by any [CallCommand] instances.
  Future<bool> isCalled({required final int commandId}) async {
    final countColumn = countAll(
      filter: callCommands.commandId.equals(commandId),
    );
    final query = select(callCommands).addColumns([countColumn]);
    final row = await query.getSingle();
    final result = row.read(countColumn);
    return result != null && result > 0;
  }

  /// Set the [pushCustomLevelId] for the command with the given [commandId].
  Future<Command> setPushCustomLevelId({
    required final int commandId,
    final int? pushCustomLevelId,
  }) async =>
      (await getUpdateQuery(commandId).writeReturning(
        CommandsCompanion(pushCustomLevelId: Value(pushCustomLevelId)),
      ))
          .single;

  /// Set the [dartFunctionId] for the command with the given [commandId].
  Future<Command> setDartFunctionId({
    required final int commandId,
    final int? dartFunctionId,
  }) async =>
      (await getUpdateQuery(commandId).writeReturning(
        CommandsCompanion(dartFunctionId: Value(dartFunctionId)),
      ))
          .single;
}
