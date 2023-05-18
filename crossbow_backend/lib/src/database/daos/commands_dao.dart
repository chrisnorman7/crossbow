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
    final AssetReference? messageSound,
    final String? messageText,
    final PopLevel? popLevel,
    final PushMenu? pushMenu,
    final StopGame? stopGame,
    final String? url,
    final PushCustomLevel? pushCustomLevel,
    final DartFunction? dartFunction,
  }) =>
      into(commands).insertReturning(
        CommandsCompanion(
          messageSoundId: Value(messageSound?.id),
          messageText: Value(messageText),
          popLevelId: Value(popLevel?.id),
          pushMenuId: Value(pushMenu?.id),
          stopGameId: Value(stopGame?.id),
          url: Value(url),
          pushCustomLevelId: Value(pushCustomLevel?.id),
          dartFunctionId: Value(dartFunction?.id),
        ),
      );

  /// Get a command with the given [id].
  Future<Command> getCommand({required final int id}) {
    final query = select(commands)..where((final table) => table.id.equals(id));
    return query.getSingle();
  }

  /// Get an [update] query which matches on [command].
  UpdateStatement<$CommandsTable, Command> getUpdateQuery(
    final Command command,
  ) =>
      update(commands)..where((final table) => table.id.equals(command.id));

  /// Set the [pushMenu] for [command].
  Future<Command> setPushMenuId({
    required final Command command,
    final PushMenu? pushMenu,
  }) async =>
      (await getUpdateQuery(command).writeReturning(
        CommandsCompanion(pushMenuId: Value(pushMenu?.id)),
      ))
          .single;

  /// Delete [command].
  @internal
  Future<int> deleteCommand({required final Command command}) async =>
      (delete(commands)..where((final table) => table.id.equals(command.id)))
          .go();

  /// Add message [text] to [command].
  Future<Command> setMessageText({
    required final Command command,
    final String? text,
  }) async =>
      (await getUpdateQuery(command)
              .writeReturning(CommandsCompanion(messageText: Value(text))))
          .single;

  /// Set the [assetReference] of [command].
  Future<Command> setMessageSoundId({
    required final Command command,
    final AssetReference? assetReference,
  }) async =>
      (await getUpdateQuery(command).writeReturning(
        CommandsCompanion(messageSoundId: Value(assetReference?.id)),
      ))
          .single;

  /// Set the [stopGame] for [command].
  Future<Command> setStopGameId({
    required final Command command,
    final StopGame? stopGame,
  }) async =>
      (await getUpdateQuery(command).writeReturning(
        CommandsCompanion(stopGameId: Value(stopGame?.id)),
      ))
          .single;

  /// Set the [popLevel] for [command].
  Future<Command> setPopLevelId({
    required final Command command,
    final PopLevel? popLevel,
  }) async =>
      (await getUpdateQuery(command).writeReturning(
        CommandsCompanion(popLevelId: Value(popLevel?.id)),
      ))
          .single;

  /// Set the [url] for [command].
  Future<Command> setUrl({
    required final Command command,
    final String? url,
  }) async =>
      (await getUpdateQuery(command)
              .writeReturning(CommandsCompanion(url: Value(url))))
          .single;

  /// Get the call commands to be called by [command].
  Future<List<CallCommand>> getCallCommands({
    required final Command command,
  }) =>
      (select(callCommands)
            ..where((final table) => table.callingCommandId.equals(command.id)))
          .get();

  /// Get the call commands which call the [command].
  Future<List<CallCommand>> getCallingCallCommands({
    required final Command command,
  }) =>
      (select(callCommands)
            ..where((final table) => table.commandId.equals(command.id)))
          .get();

  /// Get a pinned command which represents [command].
  Future<PinnedCommand?> getPinnedCommand({
    required final Command command,
  }) =>
      (select(pinnedCommands)
            ..where((final table) => table.commandId.equals(command.id)))
          .getSingleOrNull();

  /// Returns `true` if [command] has an associated row in the [pinnedCommands]
  /// table.
  Future<bool> isPinned({
    required final Command command,
  }) async {
    final countColumn = countAll(
      filter: pinnedCommands.commandId.equals(command.id),
    );
    final query = selectOnly(pinnedCommands)
      ..addColumns([
        countColumn,
      ]);
    final row = await query.getSingle();
    final result = row.read(countColumn);
    return result != null && result > 0;
  }

  /// Returns `true` if [command] is called by any [callCommands].
  Future<bool> isCalled({
    required final Command command,
  }) async {
    final countColumn = countAll(
      filter: callCommands.commandId.equals(command.id),
    );
    final query = selectOnly(callCommands)
      ..addColumns([
        countColumn,
      ]);
    final row = await query.getSingle();
    final result = row.read(countColumn);
    return result != null && result > 0;
  }

  /// Set the [pushCustomLevel] for [command].
  Future<Command> setPushCustomLevelId({
    required final Command command,
    final PushCustomLevel? pushCustomLevel,
  }) async =>
      (await getUpdateQuery(command).writeReturning(
        CommandsCompanion(pushCustomLevelId: Value(pushCustomLevel?.id)),
      ))
          .single;

  /// Set the [dartFunction] for [command].
  Future<Command> setDartFunctionId({
    required final Command command,
    final DartFunction? dartFunction,
  }) async =>
      (await getUpdateQuery(command).writeReturning(
        CommandsCompanion(dartFunctionId: Value(dartFunction?.id)),
      ))
          .single;

  /// Set the [variableName] for [command].
  Future<Command> setVariableName({
    required final Command command,
    final String? variableName,
  }) async =>
      (await getUpdateQuery(command).writeReturning(
        CommandsCompanion(variableName: Value(variableName)),
      ))
          .single;

  /// Get all the commands in the database.
  Future<List<Command>> getCommands() => select(commands).get();

  /// Set the [description] for [command].
  Future<Command> setDescription({
    required final Command command,
    required final String description,
  }) async =>
      (await getUpdateQuery(command).writeReturning(
        CommandsCompanion(description: Value(description)),
      ))
          .single;
}
